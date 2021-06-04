class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/0.7.0.tar.gz"
  sha256 "bd0873e088701eecdcf6eeb254eed7a4dbe3dd71728e272505c1b8f92c3eebe9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "557cbb8aa12ce8173aba69f12c5cfee97b31e489a08661b002bbcc8480032ae3"
    sha256 cellar: :any, big_sur:       "851c0881b1a76ce34c018c231248e6a17f11a7703ece7d0ea24c9ca36f69826d"
    sha256 cellar: :any, catalina:      "1174396eb8beb8828a66e0c5fe25cf4ecf177d305ec57404d1620fa5243f5d9d"
    sha256 cellar: :any, mojave:        "e36701a4a372cd127f0b02f0dee5ff51cd6a98ee1df6e828af36b7865677ec91"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match(/Total\.*1\n.*Successful\.*1\n/, output)
  end
end
