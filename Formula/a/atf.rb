class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/freebsd/atf"
  url "https://github.com/freebsd/atf/releases/download/atf-0.25/atf-0.25.tar.gz"
  sha256 "a52be96b5565733e71df8d0ecc8a4255a495e45183de7e3657491e0a8069423f"
  license "BSD-2-Clause"
  head "https://github.com/freebsd/atf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "4ff1a81c19dcea8c135f3b1de6a53e63724e330114973121477943148358d66c"
    sha256 arm64_tahoe:       "fb483a4bfb905030f23acc52a4d22688ff59fc01274f85522b94b79d4d60272f"
    sha256 arm64_sequoia:     "934ba19c92a9f651894a6cd0a5fac1aebea671dccc715545a20abf10c561bb18"
    sha256 arm64_sonoma:      "01d599530b6d95f2bf45736dcdab54f2e6fc9c3742f9d8d5bf4d7ea87a4649f3"
    sha256 arm64_linux:       "50061091613fbeabe2648a321a54d6d12bf7819975c18b0fd91bb3231552e7e8"
    sha256 x86_64_linux:      "ad68b17ba5aa3c92fe7999ab71686e77e57806d6b211473531825221856015b2"
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
