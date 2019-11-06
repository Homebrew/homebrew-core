class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.10.1.tar.gz"
  sha256 "034ddcab650a40ac6b5e037caa63da38429c299f5393de6f63573ad620086aa9"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e51d4fdfce6b5412b19b43c88fbf1fcf2722bbf30e6ee37c1b6b25ca228135ab" => :catalina
    sha256 "0c9184e36e1b4953ed3c2f74aadad6f84a2622a58531f7639e9e382034744a4b" => :mojave
    sha256 "979dbd553041ca8e556718c08ff56324fc2ac00e76cda88f0eb14877448e1e90" => :high_sierra
  end

  depends_on "go" => :build

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
