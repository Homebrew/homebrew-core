class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.3.0.tar.gz"
  sha256 "c71174a2fbb7b6183cb84fc3a5e328cb4276a495c7c0be8ec53c377ec0363489"
  license "AGPL-3.0-only"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f8431ea1c5b8556ae75c572eae2d20c044da0a1c3bb44395ba4b13f5916e667"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c266f64a13b0e2c96d8fc394a4cc59b4f406e3071a41aaf5d19cdf085ed560a"
    sha256 cellar: :any_skip_relocation, catalina:      "9e7bbd622f31cf1dd86251c795df0eb284a07ceb73606de61746da0e8ac0edcd"
    sha256 cellar: :any_skip_relocation, mojave:        "0c6f9f70266f6b196d78d1efa3fee4047b58a22065b14da39399fee2f717a64c"
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
