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

    # As per notes in https://github.com/SimonKagstrom/kcov/issues/166
    MachO::Tools.change_install_name(
      "src/kcov",
      "@rpath/LLDB.framework/LLDB",
      MacOS::Xcode.bundle_path.join("Contents/SharedFrameworks/LLDB.framework/LLDB").to_s,
    )

    system "make", "install"
  end

  pour_bottle? do
    reason "Need to set the XCode path explicitly"
    satisfy { false }
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
      echo "Testing Kcov"
    EOS
    system "#{bin}/kcov", testpath/"output", testpath/"test.sh"
  end
end
