class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.1.tar.gz"
  sha256 "60c30c9d6ac2e8f7eab6917684c9c843a638cd3d3f31755f9d0ec8c6839a8196"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abfd982465b57051d6d26b5f3237f4a1a4998912d86e004169dce5cb2a8804d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e82a0813303c414749c45a050fd46ab5a9318a6f81fbd4f3e829ff7565e756ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "995ec76cae2eb9c4c2125ca21bc287f35e2b7999043644fdc6924119b1bd6a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "490df86586fe865d5de91418c83c4c31b2125da4ad6d77ff410b9e7e2fb1251f"
    sha256 cellar: :any_skip_relocation, sonoma:         "125f65c119dda8ece420f0fe835afae803ac878025f141bfedca7fade784f20a"
    sha256 cellar: :any_skip_relocation, ventura:        "d8ee20c86c989156a9adfed11c1537efd6718ca0b32ff49c747eea165366b046"
    sha256 cellar: :any_skip_relocation, monterey:       "ad72fb92882eb9b4a0ce0d66ce6a079518936ad4d46d6b86df79c6a0cd381310"
    sha256 cellar: :any_skip_relocation, big_sur:        "364a4ef9a34c716241f5cf2f3e0b7de16c7de527390d542d84d8a1bf070641e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab75674aeff75685a8832b27ce8a5b44510f90b8d1a7be9db42cb90a6525125d"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
