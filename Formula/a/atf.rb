class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/freebsd/atf"
  url "https://github.com/freebsd/atf/releases/download/atf-0.26/atf-0.26.tar.gz"
  sha256 "bae70930bef565faacb95b10e5673601df0d7f25db720cc735060d115c92ee73"
  license "BSD-2-Clause"
  head "https://github.com/freebsd/atf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "d32c7b5fcf43bafd203f330128dc651ed926a13244746459a3a313e9a2127add"
    sha256 arm64_tahoe:       "9f55f3f81952f127c042c88562d74acaeeec96a2d6a696bf6c708f838ffd8e19"
    sha256 arm64_sequoia:     "aafaa35983b9a5de8703c4a84dd1443f1909ae8fdc1875637977a35d982e5b87"
    sha256 arm64_linux:       "5acf9b4ba36a227f8894be8e15615786ac4b938a616dffb217141ea0ce9bda4e"
    sha256 x86_64_linux:      "5e7ce4d277858da5ac1a3732a42995531fb2e95561ba1831daf9dd906c1cdcc2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

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
