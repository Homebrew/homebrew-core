class Localtunnel < Formula
  desc "Exposes your localhost to the world for easy testing and sharing"
  homepage "https://theboroer.github.io/localtunnel-www/"
  url "https://registry.npmjs.org/localtunnel/-/localtunnel-2.0.2.tgz"
  sha256 "6fb76f0ac6b92989669a5b7bb519361e07301965ea1f5a04d813ed59ab2e0c34"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b5425789666cab50aa13978b6bec08b978f7be5d53e13b9e447ed712dc2b3c60"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Suppress node warning during runtime
    ENV["NODE_NO_WARNINGS"] = "1"

    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}/lt --port #{port}")
    assert_match "your url is:", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/lt --version")
  end
end
