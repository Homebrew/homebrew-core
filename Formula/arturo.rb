class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.80.tar.gz"
  sha256 "25f4782e3ce1bc38bedf047ed06a3992cf765071acded79af202a1ab70b040e2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "bba16a404620746dca1eb2021079ea586c75b8c15ec7dd660fd09f9c3951a2a3"
    sha256 cellar: :any, arm64_big_sur:  "4da3f8e6a32e6c39a034baee47453976c7b83687c66d0802d5eed03c259a62a7"
    sha256 cellar: :any, monterey:       "32205aa87b1c5a94284fc2ce9b6fcf71e68cd532826666ac86b8bf455f11acaa"
    sha256 cellar: :any, big_sur:        "75df1175ce08e0bfb28fe9ca0fbedbdb63176b1cf3ea13a758526c40e55a94ff"
    sha256 cellar: :any, catalina:       "e1ce00ec372026029129d2d17180303f00a81e05e290b763924188049608071f"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    inreplace "build.nims", "ROOT_DIR    = r\"{getHomeDir()}.arturo\".fmt", "ROOT_DIR=\"#{prefix}\""
    system "./build.nims", "install"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
