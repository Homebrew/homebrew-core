class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.6.tar.gz"
  sha256 "e5f223d6309b7eecd8c3269f4c375ffedf0db8e5a9230b4b287d2de63c461616"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "747763a159d6832e7c0b64d324d8192f555dfab8269d83768955b51751891eef" => :sierra
    sha256 "a01321e051368e4cc4d214460b5c1d5f4df1d18d6a2bb0653106e378ba2b039d" => :el_capitan
    sha256 "40f24a34a885622b7a95d99ee32b39a145b5e8ee8452e5d886e8ca4b204715d6" => :yosemite
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
