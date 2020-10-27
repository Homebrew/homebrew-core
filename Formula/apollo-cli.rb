require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.31.0.tgz"
  sha256 "563a0ec96e323731d0d75d841da863f955bd8d32c201fa621cb8ea957832f9d9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d39f2a99d159bff26f2a1f636e3987b6748709a681f878869e21af720b51e75c" => :catalina
    sha256 "e55a4a9eb8519d97f43f21456c8410ba50d9a9a39334ac2c18db59f3945c9bbe" => :mojave
    sha256 "314eee29a412b2b0c14c350169fcae5df288d6cb2cc7ce8601d6046963b3daf8" => :high_sierra
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
