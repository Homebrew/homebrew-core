class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.2.tar.gz"
  sha256 "18a42b02ae548a344a79b10cd34b710f5ab964ce57a58bd516af4b0c3826fdf1"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f91cdfb6d4ecf024766a882c9135b4e9dda853b9d3358e2056c2a1a024d3dd26" => :high_sierra
    sha256 "8327a75c748239c645f97f234db5a41e41024912164f0a798b844ad2422aa078" => :sierra
    sha256 "3162267ea1ffd9a5e8f4b1981f2ca14aeebfc38e89ad9579b617b0614774f106" => :el_capitan
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      ENV["CGO_ENABLED"] = "1" if build.with? "dynamic"
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
