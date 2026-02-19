class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://registry.npmjs.org/jsonlint/-/jsonlint-1.6.3.tgz"
  sha256 "987f42f0754b7bc0c84967b81fc2b4db0ed2ebe2117ccc5a5faa59e462447723"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f385934d75bcc430e766ac449f35048cb99579b9179f8d7e38bf38459047bac1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.json").write('{"name": "test"}')
    system bin/"jsonlint", "test.json"
  end
end
