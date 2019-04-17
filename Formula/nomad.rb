class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.9.0.tar.gz"
  sha256 "fb6a0afd6895540dd5e18c878421c39e2a2759e90af8eb771c84802d082475df"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dea92611f1a36dee8dccb2ca5a82d161045f98d302dc8f7c4b6a6e9fc043bb5" => :mojave
    sha256 "9c0a1802e904edd47fba0501ec884d8a67a425cf6e275a9b1c864ccc5d10ff78" => :high_sierra
    sha256 "623884e34c258a8d2681cd1c781b60cfd28f4776c09c6fe0570603dabad7d9fb" => :sierra
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
