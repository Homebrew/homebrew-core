class Jsonlint < Formula
  desc "JSON parser and validator with a CLI"
  homepage "https://github.com/zaach/jsonlint"
  url "https://github.com/zaach/jsonlint/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "a7f763575d3e3ecc9b2a24b18ccbad2b4b38154c073ac63ebc9517c4cb2de06f"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc368b7493e0307e8011f37f29b91b296ea0adadd804484b07362f681d36fcbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc368b7493e0307e8011f37f29b91b296ea0adadd804484b07362f681d36fcbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc368b7493e0307e8011f37f29b91b296ea0adadd804484b07362f681d36fcbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc368b7493e0307e8011f37f29b91b296ea0adadd804484b07362f681d36fcbe"
    sha256 cellar: :any_skip_relocation, ventura:        "fc368b7493e0307e8011f37f29b91b296ea0adadd804484b07362f681d36fcbe"
    sha256 cellar: :any_skip_relocation, monterey:       "fc368b7493e0307e8011f37f29b91b296ea0adadd804484b07362f681d36fcbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9961017c6a0a18697ddf9b1f85349da345e8c7eb04a5b7cf816ab532c30e2c4b"
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
