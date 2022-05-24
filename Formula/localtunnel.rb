require "language/node"

class Localtunnel < Formula
  desc "Exposes your localhost to the world for easy testing and sharing"
  homepage "https://theboroer.github.io/localtunnel-www/"
  url "https://registry.npmjs.org/localtunnel/-/localtunnel-2.0.2.tgz"
  sha256 "6fb76f0ac6b92989669a5b7bb519361e07301965ea1f5a04d813ed59ab2e0c34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c430fe4d9468d9eaeeabe3c32ffd51c2c93913c3e01bc6a41b947e1acba0bb19"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # supress node warning during runtime
    ENV["NODE_NO_WARNINGS"] = "1"

    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}/lt --port #{port}")
    assert_match "your url is:", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/lt --version")
  end
end
