class OpenvscodeServer < Formula
  desc "Run VS Code with access through a modern web browser"
  homepage "https://github.com/gitpod-io/openvscode-server"
  url "https://github.com/gitpod-io/openvscode-server/archive/refs/tags/openvscode-server-v1.84.0.tar.gz"
  sha256 "13cfefd43531aec33d5e3942491213589bae9bbf168a3a471c8a68e563748090"
  license "MIT"

  depends_on "node@18" => :build
  depends_on "yarn" => :build

  def install
    system "yarn", "add", "-D", "node-gyp"
    system "yarn", "install"
    system "yarn", "server:init"
    bin.install_symlink "#{libexec}/out/server-main.js" => "openvscode-server"
  end

  service do
    run [opt_bin/"openvscode-server", "--without-connection-token"]
  end

  test do
    assert_match "--without-connection-token",
      shell_output("#{bin}/openvscode-server", "--help")
  end
end
