class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "https://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/refs/tags/0.83.tar.gz"
  sha256 "6f2df00009f5ac4ad654c1ae1d2f8ed18191de38d1f5a88a54ea99cc16936686"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "05ae4713f0c3a97e7fe336d63e5d8820f5d0e13db8fc85feb26816941fe5ca8a"
    sha256 arm64_sequoia: "4750bf34906f2399f5047a2af4b941381f91a87ebf23f702556f1e7f9e65acfe"
    sha256 arm64_sonoma:  "7f11c06f31cd0079cddced37e014f82f7b3e76eef35416e0027a0d3aa6c42209"
    sha256 sonoma:        "3f903f30f40421547ff9b2c32cd1846776ceb8ed15a1e528342bfa674f789c35"
    sha256 arm64_linux:   "44285a821b4033b99b40ee6d7689a24eca229e0b9535d64d074af9f6a61f37f4"
    sha256 x86_64_linux:  "ec2e913ae07ca6964043a8acd6ae2749ee86aba963284d115c64e58191b88a88"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # patch to include `stdio.h``
  patch do
    url "https://github.com/msteveb/jimtcl/commit/35e0e1f9b1f018666e5170a35366c5fc3b97309c.patch?full_index=1"
    sha256 "50f66a70d130c578f57d9569b62cf7071f7a3a285ca15efefd3485fa385469ba"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--ssl",
                          *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
