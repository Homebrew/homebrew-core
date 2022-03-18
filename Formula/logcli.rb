class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.2.tar.gz"
  sha256 "725af867fa3bece6ccd46e0722eb68fe72462b15faa15c8ada609b5b2a476b07"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6970a743893bea4d6a56780234f7ca0a2b7885e04ba8d4391a1d2b5d3969497"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89ac54597c71253e1c6082ae2402583753425815db899c813f730f64c88927e9"
    sha256 cellar: :any_skip_relocation, monterey:       "25fc576bd6ae13176c98a2929219581d5a4ba840b60c188577fd930beffeb7e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad76d57bc0341f332d2c1f777935e423a45e79968a8568d0ba19e9dbbbcffa38"
    sha256 cellar: :any_skip_relocation, catalina:       "18e23f7d9b91d5514e330e53ba65f192784d9824e868f5bd43478b3a237704c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1c676fe5b3133dceadab697f245f34d57a83c49793886095f8870d0cdab326"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
