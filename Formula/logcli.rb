class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.1.tar.gz"
  sha256 "a26c22941b406b8c42e55091c23798301181df74063aaaf0f678acffc66d8c27"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cba66891c11a66707b0e0c26318cd3904fcfdbfd380c889d462736fdf77dbda7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9245f7f8c3996eaeab8bb9546c49a8645b0365cc91455130456fb45caa0ab593"
    sha256 cellar: :any_skip_relocation, monterey:       "62763515fe41081122276a3c7ec6d92fd267f1729109447ba212e35f0691c99e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4acd8ba55f3619b2e4e2da7ce22224d65a0d07547a9b8cbed369a6167e46f79"
    sha256 cellar: :any_skip_relocation, catalina:       "27db69c1904c15803e28a17b25304f21782da91400664ee12af4e9e513a0a167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49ba9447ef974bd4ca5164d603247b48800e0964c1964f7d2f5b6e1bdcaecbd"
  end

  depends_on "go" => :build
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
