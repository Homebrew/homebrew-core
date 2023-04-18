class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.11.tar.gz"
  sha256 "32f69ab2215bfcf10e8fe3920c5b4ffd6e699a68463577b32c39f9189d5a9c56"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "03609e0ad0f3708665531b93140739ded5fea74f7d0fc218babdbb48a033038a"
    sha256 arm64_monterey: "c3e77b868db440c560f923fbaec6a69f28ae4848c600792973e5c0faecc57f06"
    sha256 arm64_big_sur:  "ad21e65cee744d18e51f8f6abdc87508499076a9e257193396dda941cee3390b"
    sha256 ventura:        "99682bace0e948f93b48eaf3ec71f267b6fb5ad6af41bcda255630c2225b290d"
    sha256 monterey:       "c645c3ed295f3aa4e0132859d982b0820bdad156775ca7a520d37f7316c6d51d"
    sha256 big_sur:        "7ac99369924110916793af47ed380c5932460eff91bd8b764d6eb3cf19f5e547"
    sha256 x86_64_linux:   "8c14e6075f9ce134a562cf98a4610e983e54eee55186ac5e77831b1d7d837a07"
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
