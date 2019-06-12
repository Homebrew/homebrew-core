class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.9.3.tar.gz"
  sha256 "65ae3d7c7c88f9a344f88c2444356662eaa16683d0033bf9fbff691633f4e6fe"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "4f0a3f3be8fc7a4767c1d4c51e2311cee50e297d356c749152c036a2a6e1bc5f" => :mojave
    sha256 "7ef5cd9bad3aad1f50681dbb58f80ba8fd0395baf373b5837c4116947936db06" => :high_sierra
    sha256 "d529e844ecd4fa2621146b75dee521542102d149658dd4309dfb7e8cfc92d429" => :sierra
    sha256 "b46ef347889482e15f4df3ab6c390adef2dd55f5c814843809cbd3bb38e6e4fe" => :x86_64_linux
  end

  depends_on "go@1.11" => :build

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
