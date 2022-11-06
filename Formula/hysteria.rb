class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://github.com/HyNetwork/hysteria"
  url "https://github.com/HyNetwork/hysteria.git",
    tag:      "v1.2.2",
    revision: "3d54cb43afab6bb700a35ef77b5436af5587470a"
  license "MIT"
  head "https://github.com/HyNetwork/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b80d54892daa6836fc845dda8d980f281cde4b3ccb8e1d828bfc96460a1cd70b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70691cd413d93222745e932087147c11081035f2f0e9eb8aa577d586279366f4"
    sha256 cellar: :any_skip_relocation, monterey:       "9f4e1eeb8fe4e916e9b3983a5581c4e79b89fd62f4a7a7c71db87ff6fcd2f99f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5c387936785732dfa6c1d969459b90f76cf4c026c3752bd181850cfe7bc325b"
    sha256 cellar: :any_skip_relocation, catalina:       "e568a9e23736a782fefa2f2b3eb4ad55930c6cd1e4de615b321a6d52f0557bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f7af1cc6a6e3ae1126478b7230253070b4e421421bf9bd03de4c4e528b7138"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=v#{version} -X main.appDate=#{time.rfc3339} -X main.appCommit=#{Utils.git_short_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
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
