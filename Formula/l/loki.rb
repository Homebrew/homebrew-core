class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "584d7f45cc85f884e8eb7e8ed8c35eacd2157c6edd0f2a2d0161ba39d22b86ae"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b472639552be01c08671d53b3f0329a974d6569b6ceb84c97843527fc588bb7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b31a16d28e23ddf58d161137f9e57df15cad81871e872ad0deefbcd4a8cff41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b3b614e4c1b48be24de3fc96d2961dc3fe8dd5276a5f8dc6f1b855455e40175"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd2314b675908d900ee612474c0bc86ccfe83231a718ef89e90683f615e33ced"
    sha256 cellar: :any_skip_relocation, ventura:       "1bed2c651792241aae177908aedb871ee72e64acefa38dc0c694fb317e7a2f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e36493663cf7c83661e26883b5e74df898313b988c9de28b770eddd09566fd"
  end

  depends_on "go" => :build

  # Fix to failed parsing config: loki-local-config.yaml: yaml: unmarshal errors:
  # PR ref: https://github.com/grafana/loki/pull/16991
  patch do
    url "https://github.com/grafana/loki/commit/974d8cf5b04c0043ded02cfc3ee360cdff219674.patch?full_index=1"
    sha256 "56a06b0cae70464d738f7aa7c306446f73ceea4badef0502826de9fd1d0c3475"
  end
  patch do
    url "https://github.com/grafana/loki/commit/cc34c48732229f2edf742b5f69536aaa607edc56.patch?full_index=1"
    sha256 "d8f35a91af95d5fe2c1a3c77fa4f2394cb279b88a6c4f8cf22fd2b9d8376dca8"
  end
  patch do
    url "https://github.com/grafana/loki/commit/8ca1db1d24799468c0c6d0cd6b640a60eb246646.patch?full_index=1"
    sha256 "4e2925424bcd7a093f4986d3005c888b98edcdae82b71ec4d71b957f4a9cbcfb"
  end

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
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
