class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "f4d33fbe0a57d2914b8cc94b463d3f170990f92f34251aaef1ca80fb5cd952b0"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f989686e52055247f22c5900fd8dfd10bcb62efc26b86736f4d7bd3c3f9a3819"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f989686e52055247f22c5900fd8dfd10bcb62efc26b86736f4d7bd3c3f9a3819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f989686e52055247f22c5900fd8dfd10bcb62efc26b86736f4d7bd3c3f9a3819"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2870833fb40e4c157399e3a52ef2707f116d1451687c6f093f8a342c7ad6e6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "85839c7d61358a5f7d6c062380f566aff7ce6ccefdb5506fc1f040c3a89f09b4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X main.Build=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nebula"), "./cmd/nebula-service"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nebula-cert"), "./cmd/nebula-cert"
  end

  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/"]
    keep_alive true
    require_root true
    log_path var/"log/nebula.log"
    error_log_path var/"log/nebula.log"
  end

  test do
    system bin/"nebula-cert", "ca", "-name", "testorg"
    system bin/"nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~YAML
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    YAML
    system bin/"nebula", "-test", "-config", "config.yml"
  end
end
