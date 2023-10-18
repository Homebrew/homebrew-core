class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230909.tar.gz"
  sha256 "1e5e6c76540dfe8104426cd7fd3f715cc6404f9039c9203447012b8f2f6b7b86"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93738ae91f43489913c3aefd7be4e5205d565e4e01a4cf50e078fa03fdd674de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8440d1127b497cf5b56dc890940a15dbfe1d066da3cb161866a329eb7c2739"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0b70f7301a935fe512a8c43bf30cc371e0740c892c69d7e5047bc9eca7c20ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1ac39c7f02e83b0c0f855a7f0fff5769f7548c8e1cd7586025c532630ccfd16"
    sha256                               sonoma:         "b580fa7f8c2728fd830b257155f398e53719b3a35b17dca9f83699ddb8966a49"
    sha256                               ventura:        "e3091b0d7b025e92ebb4cee41b00f2e16b32df93993413eff44af47e67020c50"
    sha256                               monterey:       "3288211f85010064e732d3bc4467a95ec776278f4903a7a3bd2aa0aa21a9a08e"
    sha256                               big_sur:        "3548dbb3c6ff9f89bd060ffd1401c7e3e7032b33b970bd081453b376f8416244"
    sha256                               x86_64_linux:   "b215b14951312912d62b9aca212ca7d402b3af826795ad61de5bb910408d43bc"
  end

  uses_from_macos "bc" => :build

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
