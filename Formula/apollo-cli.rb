require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.32.1.tgz"
  sha256 "cfeaafcc923e13a5504676c8f57965543960babc11d7d6130107c9df0d30e769"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8f780cf345fde074787dd01b56577f07fe65a953b0dbea033e070cb9cfcdfba3" => :big_sur
    sha256 "7ec608a8099758515f1ea8f5cd46b4bfe48ff374e2ba6a936faa3cc1feea3b2c" => :arm64_big_sur
    sha256 "9574905e751271e1e6fc2023fb79a22f4be705788bceb39562aa391c7adc4d09" => :catalina
    sha256 "731f921359aa48f94097a1b157fe1de37c46eebe24da054d80714c61295a05c5" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Error: No schema provider was created", error_output
  end
end
