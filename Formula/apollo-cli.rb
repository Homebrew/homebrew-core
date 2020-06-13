require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.28.3.tgz"
  sha256 "648334e38f9b8d45ceb59e216b5352d8edd60301b81d035084f823480b7136a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "24f477a5c300843b6b878726ed5a4e70ba070e8ee2b9e993e84c8c414e72b031" => :catalina
    sha256 "192c6c4e0471dd1c4fca784a92b155dca94c8c9ad253ef7f4ade32f034438137" => :mojave
    sha256 "97a36f1e9db81bfc446a41e264d3435d4efb11c777cb07d2edeb075a5a2b98a9" => :high_sierra
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
