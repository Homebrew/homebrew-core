class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.8.0.tar.gz"
  sha256 "bb028c6890bb3c556e3d4a9a431323c638b3b46c799a57a08702d3de80d412b0"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6e2fc2f4f6577e10f095d5cac4381769f96540091335ed08af08f2528b882e2" => :big_sur
    sha256 "bbad883b08572b48127ee5d033646284af7eacc62bb0622baae7400d401d26a2" => :catalina
    sha256 "35ab784a4702aa376e5936ff91fd0306dc104cbd1df76de03bed20ec1b0d2d7e" => :mojave
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
