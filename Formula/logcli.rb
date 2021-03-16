class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.2.0.tar.gz"
  sha256 "758fa26422bacda69b12e740e46fa5b97e02063a90fece14fb3fdcd7add2f7f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86e6589fa4de360f805d3ca663f976c678eba3f33b3615f904d755d88f3d73bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b6bf073e5f6398d60fa9bf14c2f6842ec7165cfebb595adaf556244326cb420"
    sha256 cellar: :any_skip_relocation, catalina:      "4bbcd22092d6e0090d1864098be53a8325d1cc723b627039f9d5c432b1d83e22"
    sha256 cellar: :any_skip_relocation, mojave:        "b73c1f5933d3fdafdffb97049deed8bc2d67865644be5b747c3bc66e9ed5498e"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
