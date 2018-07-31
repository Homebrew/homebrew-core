class Kcov < Formula
  desc "Code coverage tool for compiled programs, Python and Bash"
  homepage "https://simonkagstrom.github.com/kcov/index.html"
  url "https://github.com/SimonKagstrom/kcov/archive/v35.tar.gz"
  sha256 "74c172dae2ac2866e0adc91d3fd80276e5acb970d11ac71679a0f7336897a476"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode # Needed for LLDB. See MachO work below.

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make"

    system "make", "install"
  end

  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  def post_install
    if MachO::Tools.dylibs("#{bin}/kcov").include?("@rpath/LLDB.framework/LLDB")
      # Need to temporarily make it writeable..
      File.chmod(0777, "#{bin}/kcov")

      lldb = `lldb -P`
      lldb_path = File.absolute_path(File.join(lldb, "..", "..", "LLDB"))

      # As per notes in https://github.com/SimonKagstrom/kcov/issues/166
      MachO::Tools.change_install_name(
        "#{bin}/kcov",
        "@rpath/LLDB.framework/LLDB",
        lldb_path,
      )
      # Don't need to write to it anymore
      File.chmod(0555, "#{bin}/kcov")
    end
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
      echo "Testing Kcov"
    EOS
    system "#{bin}/kcov", testpath/"output", testpath/"test.sh"
  end
end
