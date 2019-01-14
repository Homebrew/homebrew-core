class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.7.tar.gz"
  sha256 "f74eac627de69190e586358b1956573a0ae1a40d0755ecdee163016949f9c7fe"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6bff223fa37c6e1d773ebbfe42cbb8619e37fceb3b5552fcc16edbf309310b7" => :mojave
    sha256 "e801bad44b4a04b7322599c57cf422fc4c1b8e0a253dd3e453e6f50e5c4e2fa2" => :high_sierra
    sha256 "c8639e939acd130aadfb77788b6412e9622c856af5ea00e6e19a078ed56154af" => :sierra
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
