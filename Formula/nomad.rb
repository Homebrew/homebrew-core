class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.4.tar.gz"
  sha256 "5571ee16b24dc4f13971cb3dfaecc67ad5e9db6efb644a409e79187a95564276"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df0259cc74d7c5b1af890a88b9e3b5a968d439e80962dd50f73131840e744963" => :sierra
    sha256 "d6ffc03e9e5266855b0df0529ff1657ed620a28d43beca9def982b5de4c0a88d" => :el_capitan
    sha256 "ea62d3ea038d25bd3b05a602665f2d971913fc86a30122788d211ef848147de1" => :yosemite
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      ENV["CGO_ENABLED"] = "1" if build.with? "dynamic"
      system "go", "build", "-o", bin/"nomad"
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
