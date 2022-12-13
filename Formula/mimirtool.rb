class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git", 
        tag: "mimir-2.4.0",
        revision: "32137ee2c4c41fa649abfb9582e1f33a9e13363b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "cmd/mimirtool/mimirtool"
    bin.install "cmd/mimirtool/mimirtool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimirtool version")
  end
end
