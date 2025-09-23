class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "caae437c5add69761a3772c51b4bd32a5d5f03440fdf16966ab27c7036eb2701"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4441f114f6320d47112588695bb088f000fae0c2c9ac613c75bcf020edbf8f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9071ae58a624a7a31bf8e1b14d20cea1d88717f67c385e0e9dc9e2a24c45d6cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd872ce679eb55d0f427dd65576f7280d00a919ba555b1d9ac9a72aa174f3265"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9d0e3144c2caaf53cf2aae185432ebf8d096b421797b4ad6db840c252ca22b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a88407ded88d75a282a0480047704e0f3767c1be3114cd19ed0c05c930d0e4"
    sha256 cellar: :any_skip_relocation, ventura:       "de5d1313e5e60bcfb819b6d5865ebbd07bc069bf067cc0fbe94e4dbddfc2aa95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1fa87036fd6453f32860f8d3f78dbd7ed2db76dd1614c59f4de8b279a4074aa"
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

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f49c120b0918dd76de81af961a1041a29d080ff0/loki/loki-3.5.1-purego.patch"
    sha256 "fbbbaea8e2069ef0a8fc721f592c48bb50f1224d7eff94afe87dfb184692a9b4"
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
