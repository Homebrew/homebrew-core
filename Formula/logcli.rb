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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e48cb9a1712fbf6c060831ad0f9f3b34c967fc9845086d6a85a8f3fa8bcdf30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "917553c13f5adad23133d5f382b63c7ec609c05fe2b0715dfa0a5203a72a141c"
    sha256 cellar: :any_skip_relocation, monterey:       "c2771673935d7cdce2f5ddcffda25b7347ed885f744a07d720609b0f299e3674"
    sha256 cellar: :any_skip_relocation, big_sur:        "edf79dc13d6ad101394a0558e95bc15deae30d337320cf4803844aa464828a8c"
    sha256 cellar: :any_skip_relocation, catalina:       "3edb14dee5ad3db0948c8dfd0b7641d6cafed457efd78549155369762510a5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b1d6a4f292a591fc876a658fc1c61755439f1d628076a96b68b5552ac2e3eb"
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
