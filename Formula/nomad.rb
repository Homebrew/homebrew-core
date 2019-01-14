class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.7.tar.gz"
  sha256 "f74eac627de69190e586358b1956573a0ae1a40d0755ecdee163016949f9c7fe"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a72bc9a59af130df1c630f322f981d2aba9bd59ba3f5208f883b78c014dcd355" => :mojave
    sha256 "beb1081e8b25c14e0cab63f9081292533e43adf6b06c587aa72a1a5ac15e9b89" => :high_sierra
    sha256 "be3396776f78d117819e643f73353344a23a52f57067d592571498dad6dde884" => :sierra
  end

  depends_on "go@1.10" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/hashicorp/nomad"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-tags", "ui", "-o", bin/"nomad"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/nomad", "agent", "-dev"
      end
      sleep 10
      ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
      system "#{bin}/nomad", "node-status"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
