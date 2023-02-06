class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria.git",
    tag:      "v1.3.2",
    revision: "dd4c17972fdfef7517c22d017ec922463fb94350"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9974a3ab36979c2aeb2fafc6f161f9f3494f114aa38f3afbd86d11e9d4e526fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69339147938a4dad7451c447b7813fa84a72ba1c1aef2a691e0c9883262bd7fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ece43c60d3c91a9c978b1e83fd6f90b4c1a334dc1cdd2be9e69d503f39067338"
    sha256 cellar: :any_skip_relocation, ventura:        "44fddc743d5549a3d878ee4feb5ee4afe059887153fd2b59af2a8053268155cc"
    sha256 cellar: :any_skip_relocation, monterey:       "b32251960d710a8d4363833f3b8f88b245967b70b8d7d24ece007062b77fd7e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf1628c3a717a673d0b439188c9e43ace882b1e385e25da7973ec00bb1b6d268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a401d92d1e430e2d5d87bbbe3302bfaaaaf0bbdf71dff6bae4c4e16c81e6fed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=v#{version} -X main.appDate=#{time.iso8601} -X main.appCommit=#{Utils.git_short_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./app/cmd"
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "listen": ":36712",
        "acme": {
          "domains": [
            "your.domain.com"
          ],
          "email": "your@email.com"
        },
        "obfs": "8ZuA2Zpqhuk8yakXvMjDqEXBwY"
      }
    EOS
    output = pipe_output "#{opt_bin}/hysteria server -c #{testpath}/config.json"
    assert_includes output, "Server configuration loaded"
  end
end
