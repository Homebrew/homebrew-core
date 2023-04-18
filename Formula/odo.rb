class Odo < Formula
  desc "Atomic odometer for the command-line"
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha256 "52133a6b92510d27dfe80c7e9f333b90af43d12f7ea0cf00718aee8a85824df5"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2fad51300e663cba126f61573c740198f66f1f8a505b8907605892ab1a0c48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddc4ba217251c6827fcd32c3fda2df9c294305dddc68d976072cef25c4dd768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6606d59561c5bfb5f3b6835c16e64c6d6bf25ddc85658900a735657faaf0660f"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee366eac5d82a7b60d33771791e9f44b01e648d77171b49793b5b54ae8d9ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "42158ce35f352cb5f7172a840cf7284ffe584b36d9c080e1836d0cb03aa17c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "366bcdb5f386521638f9f654b04a74e47364e1d59fa42ccca1d1f96b5a03a855"
    sha256 cellar: :any_skip_relocation, catalina:       "e5d74a7c45e3d3e8781b1b7d563733953cb15e6dffed8bcc525b063dbd5d7d69"
    sha256 cellar: :any_skip_relocation, mojave:         "f2bee7fa62ba66589fb75b3eb9b32c843e0bfc4f054521876fd891388765eec9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0bfc54617186d149c98593c74dfaa59a42b2edcc7df1855fd452594ec42f1476"
    sha256 cellar: :any_skip_relocation, sierra:         "06af025b0a2df201a9b79944dcc4809708b305242622a90c92a9906a18adf2d6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "979cc7131a35180614e848fa5fa12a72f734da7321358c89dfbd425fc8dff837"
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
    system "#{bin}/odo", "testlog"
  end
end
