class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://github.com/zaach/jsonlint/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "a7f763575d3e3ecc9b2a24b18ccbad2b4b38154c073ac63ebc9517c4cb2de06f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "97762cc27f840903d10f585400d3a9019ff18813ce89ffc25cf4d13390479a13"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write('{"name": "test"}')
    system bin/"jsonlint", "test.json"
  end
end
