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
    sha256 "1fc3c00f4a19c5d6d14ce4d0d1d13359af23b7ffca125aa6bb8cf60add7ed681" => :big_sur
    sha256 "f434c8484763c0a4d6bf7a07388479066e7c7a7ccb4393625a8e98d12fc213a1" => :arm64_big_sur
    sha256 "e03caea9f82ef5c0c26ae30764cd11892624aadc24ad18550b1a9e857d4ad187" => :catalina
    sha256 "c39c0db1b4c63c3822926d584557f80217349ae55f85068530aac9f964a7dc69" => :mojave
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
