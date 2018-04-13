class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.0.tar.gz"
  sha256 "de3283c59623502fa1e379027b2ab65c7d73aa983eefcf746259a6ba39dc2c7c"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48ca9b07c7c5e20fa35341c1780a9bcc90edc1073386c5fda31926ebbce6141a" => :high_sierra
    sha256 "dbe43b0a518a19d2c05f4464888b2dac566257d59a1cdf2ad672b102a0f5ae99" => :sierra
    sha256 "72a96db3006ed22e86cc9ce707dda4ec8c0ecd480522258b52b88e6f93b54d2a" => :el_capitan
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
