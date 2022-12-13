class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria.git",
    tag:      "v1.3.2",
    revision: "dd4c17972fdfef7517c22d017ec922463fb94350"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "496488fc9dd0f0b5578d151cdb0a5b2df051bcfaf07b8bcd01bdda526b3d3a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "223f765d16c52c6e35835a1e48e6ae9956f8b5d8a52de1c223da114f346a5a5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285a7c5aaaaafced643689d1fc07f1b25f7ce3ac7d5d8a09690e5e85d90a352b"
    sha256 cellar: :any_skip_relocation, ventura:        "5fc3e1e72740bd258548a2bb2f156e6e5a0da3f3f99a979e07fd120ca79ccba3"
    sha256 cellar: :any_skip_relocation, monterey:       "8fc8f7f2a22c1a07b65b14264eddadb17a95e4251d3ad486c368542ee7491e5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "beba1ffb750637d6eb00941a1e7c236e41796197a38b117d955577bfc177c1e4"
    sha256 cellar: :any_skip_relocation, catalina:       "31ff35aed85c899efd3ff5b3bd48e32f0828296d4c8a0934bf7f970c538c2a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961032d7ef23decddc43e032bb4027a9f914696feaf23fbb6ea7bf8f932d9b7e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=v#{version} -X main.appDate=#{time.rfc3339} -X main.appCommit=#{Utils.git_short_head}"
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
