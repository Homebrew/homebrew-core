class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria.git",
    tag:      "v1.3.4",
    revision: "b94f8a1eaf939a1f3efb469cbca1c3442db78dbc"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de9815a0911b6a3b2f48ca6c782f52dc2fca6d503521c42fcc66b7624893562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8de9815a0911b6a3b2f48ca6c782f52dc2fca6d503521c42fcc66b7624893562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8de9815a0911b6a3b2f48ca6c782f52dc2fca6d503521c42fcc66b7624893562"
    sha256 cellar: :any_skip_relocation, ventura:        "e1fb9faf3c224055957dc81d616fa671ec8212e9f23356a147f3dd13031baf10"
    sha256 cellar: :any_skip_relocation, monterey:       "e1fb9faf3c224055957dc81d616fa671ec8212e9f23356a147f3dd13031baf10"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1fb9faf3c224055957dc81d616fa671ec8212e9f23356a147f3dd13031baf10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01be1ad5a35916844c9cef51fadeb1d8c79211de8644968d100d3b46ed03ce5"
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
