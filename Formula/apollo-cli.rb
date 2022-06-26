require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.33.4.tgz"
  sha256 "a32f25b86e2a200f08c762100239ec69a76990fc53ce4b8f6b355a966f6a84a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "394ce99bc7c26f5690980007a6e92e998acc682378b67fd8dd370655d7e87f39"
    sha256 cellar: :any_skip_relocation, big_sur:       "177b60ba635cb722708dabf6f29cfdff587b33331e82d27450bba242cca10b5c"
    sha256 cellar: :any_skip_relocation, catalina:      "177b60ba635cb722708dabf6f29cfdff587b33331e82d27450bba242cca10b5c"
    sha256 cellar: :any_skip_relocation, mojave:        "177b60ba635cb722708dabf6f29cfdff587b33331e82d27450bba242cca10b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8080e3a3d1c62e3f7fc42ff39aa13a4fd59a3317e4a57073ee004fd1fded9d44"
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
