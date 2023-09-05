class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.14.tar.gz"
  sha256 "2c15c8198abd3c060014874d7f0ee7b9cfa3bc8715c65375ca7a79c01c4064bc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "1c417d9b17b0aad57e294ee5b5fea6c5cba1cb3031974aa2521cdaf09b140546"
    sha256 arm64_monterey: "6c97b1a8430e40fee72b166a07bb951db2c7267ea7f60158fb5dcb239d440c96"
    sha256 arm64_big_sur:  "d3e968a988633d1dfc24fbb457cc7c23a2a3bae5f83df1ebbb697e59fa8da228"
    sha256 ventura:        "a7a4b61502ab4bec7c1cdb4270c21d011b5417c461e5599f799ece1e0809877e"
    sha256 monterey:       "0f213e28999892d04cad8ead8cd9d7d7d0fa5bead125e0cb688cc93b31a771b3"
    sha256 big_sur:        "c4b7b189d090a23c326e2622eecfd63fe43ed0b154c79d2769c0401560d4c225"
    sha256 x86_64_linux:   "7246c35e307ac7a0928f36fd32a25ddfa0a745c62da02a6966498fa582febd03"
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
