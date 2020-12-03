require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.31.2.tgz"
  sha256 "8616b5b3b2a30c9b54465cebb569dee8bbd34e654c70a3a71e6c73f2b86a1d77"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "769c274612448b31d93687efba8a63061025aecdbf88a44b873ea03fdc0cb1df" => :big_sur
    sha256 "12c1d57b6126e1c2206c0d1d05a2bbbfddece90fb17d3998405e863870e2b494" => :catalina
    sha256 "7e8bae8c3b8c50852148a055e09a4adfcf9ebdaeabb4d2e46685c17fb6462c23" => :mojave
    sha256 "e00e9cc67ae1dfd0365a813acfdbe067fde6ae86130b8a027b64ef2d50df71b4" => :high_sierra
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
