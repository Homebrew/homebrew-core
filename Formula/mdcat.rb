class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.23.1.tar.gz"
  sha256 "0254f2611df58a320057dd467b6925eb2ddc5dfc163f298fa57099f50bacbde1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d1886c20e053b97c43750f9bf953ebbb7ef3c66648dccb03b47076d0c5902d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "e52303d0ee7e8dd69f10290358f1e1b46457a56063173793ea2f3a8506d11bb0"
    sha256 cellar: :any_skip_relocation, catalina:      "fb0faeb8cd359011ac2d73c1e6f18bd7204af76a2662a7696c02e5a055bc7380"
    sha256 cellar: :any_skip_relocation, mojave:        "484e335714e81c352005b784bd64b20d42d6887e13642dca4e84b5194697e6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d38d16de6d351b0a9889003cf1f7045091e542fc60761899ec299827f6f0f6c"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
