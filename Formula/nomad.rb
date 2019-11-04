class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.10.1.tar.gz"
  sha256 "034ddcab650a40ac6b5e037caa63da38429c299f5393de6f63573ad620086aa9"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ed7b9edf27679c41ea2e17deee6d40902558ee124237e41c694d17cf6225a76" => :catalina
    sha256 "5f80d2d07c6c878c83abc9f96471c93a948b769ff426d0e16ab5af9f21a590bf" => :mojave
    sha256 "ee5f5eac3f7a14168319a5891b2cead0183ce2c95b005ef2e8de28f030107163" => :high_sierra
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
