class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.9.5.tar.gz"
  sha256 "f5dcc802cd07756f169c24dda637fe32f8b2cb6c6bb71bb2b3f4d7f3def8223b"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6710cbb7689e2c25e21124c81c68f44ef96aa02d3bd89d3c6c26cf957429087c" => :mojave
    sha256 "65c0c8f530ec5e595b83da0031be82cfc1a4dec6980db1ae87e07b80f595a245" => :high_sierra
    sha256 "4f0a898c7c20acd8f928079d609b63e5445a81264131d57b49ebd9d542a85d89" => :sierra
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
