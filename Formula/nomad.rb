class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.5.tar.gz"
  sha256 "250c2bbd06ebfb03a8fe747455855af02e3f318724ba01762ab609e4ae600097"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fde97603ae3768354da259bacc34e88e7e049feb99b55e733c0b2548c2cc4f0" => :sierra
    sha256 "fe947e847507b62c3b43941e1737713bc0800fc4c84677772f0e76eab3e20a23" => :el_capitan
    sha256 "c7c00907f74f9330771bf3f87604f77bf390cb4651e84d1b3eb936e411269d38" => :yosemite
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
