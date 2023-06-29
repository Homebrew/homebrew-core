class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria.git",
    tag:      "v1.3.5",
    revision: "57c5164854d6cfe00bead730cce731da2babe406"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "590b5440ea6348e190e579bf6d92e0030c88c1e41d8924d688184dac998add0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590b5440ea6348e190e579bf6d92e0030c88c1e41d8924d688184dac998add0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590b5440ea6348e190e579bf6d92e0030c88c1e41d8924d688184dac998add0b"
    sha256 cellar: :any_skip_relocation, ventura:        "2e4a2e773aafe7bc57c15ac6f2aab7f78791ea2095a0dafa8bc3d12055f5588a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4a2e773aafe7bc57c15ac6f2aab7f78791ea2095a0dafa8bc3d12055f5588a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e4a2e773aafe7bc57c15ac6f2aab7f78791ea2095a0dafa8bc3d12055f5588a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8635bc4da9255afb22cb697da0103d0c37a0b2de97f0bda58d3297f158186f6"
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
