class Odo < Formula
  desc "Atomic odometer for the command-line"
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha256 "52133a6b92510d27dfe80c7e9f333b90af43d12f7ea0cf00718aee8a85824df5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e5d74a7c45e3d3e8781b1b7d563733953cb15e6dffed8bcc525b063dbd5d7d69" => :catalina
    sha256 "f2bee7fa62ba66589fb75b3eb9b32c843e0bfc4f054521876fd891388765eec9" => :mojave
    sha256 "0bfc54617186d149c98593c74dfaa59a42b2edcc7df1855fd452594ec42f1476" => :high_sierra
    sha256 "06af025b0a2df201a9b79944dcc4809708b305242622a90c92a9906a18adf2d6" => :sierra
    sha256 "979cc7131a35180614e848fa5fa12a72f734da7321358c89dfbd425fc8dff837" => :el_capitan
    sha256 "ebfc6a2e616694a3862b1d6d11dda1a2c1cb4c966447678b342457490e0e0abc" => :yosemite
  end

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
