require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.15.tgz"
  sha256 "41d59916413fb9ebf046ee6e50d63448e100ecc46b1cdd9add79b845b59e3adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfee5c3f6984197e801cf3390d62cf56b17a57a5da7bdb263bc41ee46ef2fb5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfee5c3f6984197e801cf3390d62cf56b17a57a5da7bdb263bc41ee46ef2fb5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfee5c3f6984197e801cf3390d62cf56b17a57a5da7bdb263bc41ee46ef2fb5b"
    sha256 cellar: :any_skip_relocation, ventura:        "a170fc6a15378480ee7fd2db99fc73e427d7c9323fa565760580040fcdd78faf"
    sha256 cellar: :any_skip_relocation, monterey:       "a170fc6a15378480ee7fd2db99fc73e427d7c9323fa565760580040fcdd78faf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a170fc6a15378480ee7fd2db99fc73e427d7c9323fa565760580040fcdd78faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfee5c3f6984197e801cf3390d62cf56b17a57a5da7bdb263bc41ee46ef2fb5b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
