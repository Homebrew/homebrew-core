class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.2.tar.gz"
  sha256 "18a42b02ae548a344a79b10cd34b710f5ab964ce57a58bd516af4b0c3826fdf1"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "878e086ab495a10d3adf52a41a56551e22e0807ae17d2cb3d93d35716658232c" => :high_sierra
    sha256 "03cae4d45075a262e58ef8f32fa00540e4e37b36e8b4436b5ede9b1afad73c51" => :sierra
    sha256 "ba5ab3208d3be2f4046e9ad7cbfb2b715132ac217b30dfe85c24d35c7abea177" => :el_capitan
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
