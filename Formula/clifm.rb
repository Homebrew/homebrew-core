class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.12.tar.gz"
  sha256 "a4cd97d7aa184a60e3e42ff33e6a31161818149c80caa92282cd2118e73319eb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "045aebd3bcdedaa3f7ce778d9059211952bc0564353af64b6a754f5885aaba2c"
    sha256 arm64_monterey: "bac289870dd5a70e62bae9e58f6f1f9c30adb29a031e2d978686962c65f31589"
    sha256 arm64_big_sur:  "330b9b4cb5f0e37a7c8037a7ab263ba6489f1d7354d23a55d548fe6a53473847"
    sha256 ventura:        "16a2df1345de45a543ca2a8b642c2dcae8b9a3b33d215d00e13ed6b220484106"
    sha256 monterey:       "1ea90d3dd445f3154134cd2ccbb9d46ba397bb9fbaa32eef3be3bcadde6ed473"
    sha256 big_sur:        "af1564a6147876e478ddd9ae3c2b0b96a15b7d46c67630b8ad7415bdfb819ea2"
    sha256 x86_64_linux:   "719a1182f3fce2c61bdf71e9312c340c4fa6ccc9e8aca18e410c587802a33d61"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: nonexist: No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
