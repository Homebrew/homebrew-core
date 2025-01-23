class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/freebsd/atf"
  url "https://github.com/freebsd/atf/releases/download/atf-0.22/atf-0.22.tar.gz"
  sha256 "e186c079b5140e894bcb6936a08db4f4bbcb816c8497a7e8d7d34344b4ee1b63"
  license "BSD-2-Clause"
  head "https://github.com/freebsd/atf.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "ec7ee677a1def2695ddcbdf5d1274d4974d0c79e0346902d43f00839369c34cc"
    sha256 arm64_sonoma:  "edc2041e0800951b201b98ddd61cc90f4c3367194a25782423a3d51d2831aaa3"
    sha256 arm64_ventura: "0775afaaa894c7189eb81f51b361790032a0b66eb80bf24e721ceae3219bc540"
    sha256 sonoma:        "49d27cf63a14a4eeff0c85cfbb0e651cb6fc1ef05a50636bc2d33ba5011ffd1e"
    sha256 ventura:       "489e7b6bc5af5cfde192dd22a4815ef5eea8dcba5517c9e2f082cb3dba361fec"
    sha256 x86_64_linux:  "4fe4da6d61f2e1a62cb85161526f7030a594af492d2de5965b593638ae13fe07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/usr/bin/env atf-sh
      echo test
      exit 0
    SHELL
    system "bash", "test.sh"
  end
end
