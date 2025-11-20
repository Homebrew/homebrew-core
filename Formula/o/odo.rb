class Odo < Formula
  desc "Atomic odometer for the command-line"
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "52133a6b92510d27dfe80c7e9f333b90af43d12f7ea0cf00718aee8a85824df5"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "20a6c15a93b22bf5a00cbe51b03f517b71ac79ad055fe0a446b6b1296b25b0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "42a837f21b67949d9a12872adc2b2b62553071b86d947ff7640eac9547a00261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aa9f769724fe6c4fe7e3d0e383db74f03100a7fd90a947cc2df1835505829aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2fad51300e663cba126f61573c740198f66f1f8a505b8907605892ab1a0c48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddc4ba217251c6827fcd32c3fda2df9c294305dddc68d976072cef25c4dd768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6606d59561c5bfb5f3b6835c16e64c6d6bf25ddc85658900a735657faaf0660f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfe100be3b80f12c312de93500351befbb376e7991e9f0d86c2a67c9a9f43785"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee366eac5d82a7b60d33771791e9f44b01e648d77171b49793b5b54ae8d9ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "42158ce35f352cb5f7172a840cf7284ffe584b36d9c080e1836d0cb03aa17c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "366bcdb5f386521638f9f654b04a74e47364e1d59fa42ccca1d1f96b5a03a855"
    sha256 cellar: :any_skip_relocation, catalina:       "e5d74a7c45e3d3e8781b1b7d563733953cb15e6dffed8bcc525b063dbd5d7d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "247595e46c20ec2a990af435321894b79bb0d641dde13a5586e81b421f67794d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23644efe576abf9c3e3a469cf1baad05b3a3cde749998045b2992c290cf57884"
  end

  conflicts_with "odo-dev", because: "odo-dev also ships 'odo' binary"

  def install
    system "make"
    man1.mkpath
    bin.mkpath
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"odo", "testlog"
  end
end
