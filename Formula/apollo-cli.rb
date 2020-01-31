require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.22.0.tgz"
  sha256 "eb0dc30fc26752b2b9158a2bb2578f57995cf5672b73de0572e12cf5f171c8ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "29c81691e1a97d41af3ecc8f6da099949a812f07e2562b67e46bb1c8be44970e" => :catalina
    sha256 "c456360ef7925a9727eafda05bf930f4c1b547b1418446ef53cbeae80c230ae7" => :mojave
    sha256 "d1e694d958d51f02ba19ecc156d33625950031d48aff064ffc8b3b73cd591dc0" => :high_sierra
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
    assert_match "Please add either a client or service config", error_output
  end
end
