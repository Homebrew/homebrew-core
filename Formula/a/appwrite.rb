require "language/node"

class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-5.0.1.tgz"
  sha256 "7ea4c4dbdc6ae6a9700a3b403a050f3d125e78eb479bd5b7db1bb32f61159944"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e8ffa1611028d6cd965e248a9c48404bd7428815cd67b0a90df980536ca5285"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8ffa1611028d6cd965e248a9c48404bd7428815cd67b0a90df980536ca5285"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8ffa1611028d6cd965e248a9c48404bd7428815cd67b0a90df980536ca5285"
    sha256 cellar: :any_skip_relocation, sonoma:         "54f02ef444dcb890015dc6ca90161a45e2cb546a135e20bf65277c8f759d86f8"
    sha256 cellar: :any_skip_relocation, ventura:        "54f02ef444dcb890015dc6ca90161a45e2cb546a135e20bf65277c8f759d86f8"
    sha256 cellar: :any_skip_relocation, monterey:       "54f02ef444dcb890015dc6ca90161a45e2cb546a135e20bf65277c8f759d86f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e8ffa1611028d6cd965e248a9c48404bd7428815cd67b0a90df980536ca5285"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
