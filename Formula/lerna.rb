require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.4.tgz"
  sha256 "4ff45c75f5cbedffae49e0e39b09a7ab9041e27d19211897e30790f22a9e473e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a747acad6b0743bd5478bbd268d8f598cd2e7901179e8afb90e9d1ba0bd4a0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a747acad6b0743bd5478bbd268d8f598cd2e7901179e8afb90e9d1ba0bd4a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "52ac8acf99be57e095ad0dc4e0a0971c3771f19af323b35e0f3548685d2989f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "52ac8acf99be57e095ad0dc4e0a0971c3771f19af323b35e0f3548685d2989f6"
    sha256 cellar: :any_skip_relocation, catalina:       "52ac8acf99be57e095ad0dc4e0a0971c3771f19af323b35e0f3548685d2989f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a747acad6b0743bd5478bbd268d8f598cd2e7901179e8afb90e9d1ba0bd4a0b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
