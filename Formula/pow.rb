class Pow < Formula
  desc "Zero-config Rack server for local apps on macOS"
  homepage "http://pow.cx/"
  url "http://get.pow.cx/versions/0.6.0.tar.gz"
  sha256 "225e52bdc0ace5747197a5ece777785245110e576a5136a3d17136ab88a74364"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f7818e8a3d09cb9a035d11e96c8a47415022d9365f45c7ab4a4cb45d0c23d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7b025606aeafec695f040a5e35891ffb5a37f999b70a9960435863509e0746e"
    sha256 cellar: :any_skip_relocation, monterey:       "e08c6dcc8377016d4240a1b1092252a8f58f12d788ff0d49485e47dfc1c9024f"
    sha256 cellar: :any_skip_relocation, big_sur:        "148533a078c8f6675c9994a2118fc27e5e4f60882844f9dfed2f756c2a26e926"
    sha256 cellar: :any_skip_relocation, catalina:       "148533a078c8f6675c9994a2118fc27e5e4f60882844f9dfed2f756c2a26e926"
    sha256 cellar: :any_skip_relocation, mojave:         "148533a078c8f6675c9994a2118fc27e5e4f60882844f9dfed2f756c2a26e926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1172eca858ea568c110ef3dc88bd840c3b36378fa6ca238ba44a072e89fb6e"
  end

  # The related GitHub repository (basecamp/pow) was archived sometime between
  # 2018-06-11 and 2019-04-10 (referencing Wayback Machine snapshots)
  disable! date: "2022-07-31", because: :repo_archived

  depends_on :macos
  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"pow").write <<~EOS
      #!/bin/sh
      export POW_BIN="#{bin}/pow"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/command.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Create the required host directories:
        mkdir -p ~/Library/Application\\ Support/Pow/Hosts
        ln -s ~/Library/Application\\ Support/Pow/Hosts ~/.pow

      Setup port 80 forwarding and launchd agents:
        sudo pow --install-system
        pow --install-local

      Load launchd agents:
        sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
        launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
    EOS
  end
end
