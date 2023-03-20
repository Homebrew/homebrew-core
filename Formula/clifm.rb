class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.10.tar.gz"
  sha256 "b3c0bd5875009dccca8f69c6c25946f13584a34ee773af769fa53186a0e186e2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "5b05f0c255d9426ac5e1f0927247a0354f92a430190ecff8ee21cad225b2a63f"
    sha256 arm64_monterey: "b77c5aaa4f9b06e1e405d0521790df05e5e2b66b8e84c52ac161947b89087435"
    sha256 arm64_big_sur:  "e7e2c894252d77644b24b221a6789a5d2ee6240127b83d6f4f6e654edbd5baf6"
    sha256 ventura:        "e9232f3b9363affc06eb827e51749d72bdf0a1466b2bad9ed0006ca56f887015"
    sha256 monterey:       "088afc1daafd6a877d4a20dfa3fd5719ebcbafb51a63288de5e1fedaeccaadec"
    sha256 big_sur:        "2264111518a1e7bdc9372e2cfd4134b9dfc7a79143421ee4de8f2892baa8b2c8"
    sha256 x86_64_linux:   "b7c205434d1f62523eecb3cc4c425bf6407ff9c04a5567b234cb0861a764bcbb"
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
