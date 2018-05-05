class Kcov < Formula
  desc "Code coverage tool for compiled programs, Python and Bash"
  homepage "https://simonkagstrom.github.com/kcov/index.html"
  url "https://github.com/SimonKagstrom/kcov/archive/v35.tar.gz"
  sha256 "74c172dae2ac2866e0adc91d3fd80276e5acb970d11ac71679a0f7336897a476"
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "."
    system "make"

    # As per notes in https://github.com/SimonKagstrom/kcov/issues/166
    MachO::Tools.change_install_name("src/kcov",
      "@rpath/LLDB.framework/LLDB",
      "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/LLDB")

    system "make", "install"
  end

  test do
   system "#{bin}/kcov", "--version"
  end
end
