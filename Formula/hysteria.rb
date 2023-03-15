class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria.git",
    tag:      "v1.3.4",
    revision: "b94f8a1eaf939a1f3efb469cbca1c3442db78dbc"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f549681c33859de4225cb78da176490ce43c46c0570e4283bc18dd5717380d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e013555111dd756b44a33c8eaa14f30f712b38eec55bee1172b3c41b3671b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f0ea36979fb9fc7bf8b130ecb954dc5f3a356534ea396516934a0584a4da84f"
    sha256 cellar: :any_skip_relocation, ventura:        "05f6803b8d66426c196e811001f1777787b66fe993a59e15d0833c5516e0d73f"
    sha256 cellar: :any_skip_relocation, monterey:       "be124ace23c5ebb330ab1a437c89f3c25d6e11fa6f6b94813564eff3139442dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3d4e959cd83a17ac58142d085bb4837feebe8bd94ad8aefb2609d3d4ea4056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91b2c6569945bb476ebbe6aff5a1fa900b1d46de241bca7b998201c2109ce011"
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
