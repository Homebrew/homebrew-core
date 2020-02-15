require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.26.0.tgz"
  sha256 "20b07ea419c13cd89ad75978b9f891cd01b19d6e1699ee550fa9c9a2110a416d"

  bottle do
    sha256 "9c983ed61881b06cf1c8d49438d883574435a5b2f946d3b32a05759f6745b4bf" => :catalina
    sha256 "121ca0f021b82be065429b3d2816a3303c6c1b20c3ca87dffc772aec9fd060a2" => :mojave
    sha256 "0ec89dc98c5dab3f3c5b2c05c52d0fd126cd39209736cfa1bf452a5afe2930b3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end
