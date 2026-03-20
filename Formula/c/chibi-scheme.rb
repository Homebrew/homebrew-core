class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "https://github.com/ashinn/chibi-scheme"
  url "https://github.com/ashinn/chibi-scheme/archive/refs/tags/0.12.tar.gz"
  sha256 "b70a1147bc70a0f90df3fb6081bc99808237fd17a9accf9ee7a2cc20d95a4df0"
  license "BSD-3-Clause"
  head "https://github.com/ashinn/chibi-scheme.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "be30e47d3ca1602e832427792d73ca8b9d7253ee2e0d26ad08bdbf36747decfa"
    sha256 arm64_sequoia: "43d38de30e0c948fc0e3f8fed01cdc4cd0f310e324b8ca74a9c4fffe12235674"
    sha256 arm64_sonoma:  "5ef6a966e70ef198ea715addd85201027e28f2830f8a836c9ca5f5e1eac05d83"
    sha256 sonoma:        "971ba79197b82688d88d010a786789cbcd7924aab1bc7a8e57e1e1f3efb2d64d"
    sha256 arm64_linux:   "b5bd70532e6e7e9d56dd36ac48537bdce0e212021336edb1ac16ac4a5fd8bd07"
    sha256 x86_64_linux:  "dca1976f433bd1fa6f0d3125e0ec9a5a9b70f390834a1d6fbc1d66eaa91c4680"
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chibi-scheme -mchibi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
    assert_equal "0123456789", output
  end
end
