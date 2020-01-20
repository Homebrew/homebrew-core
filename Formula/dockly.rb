require "language/node"

class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.14.4.tgz"
  sha256 "6c24f868e063693c3274ce6f3219bbc852bde7b9532235ac1463fe3698b75c16"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "--containerFilters string   Filter containers", shell_output("#{bin}/dockly --help 2>&1")

    assert_match "ECONNREFUSED /var/run/docker.sock", shell_output("#{bin}/dockly --containerFilters=\"name=test&status=running\" 2>&1", 255)
  end
end
