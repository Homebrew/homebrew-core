class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.6.1.tar.gz"
  sha256 "0c81b4f74c034db96f12386115ac5e549113a80a80fb34b7edc31b139ef6bf17"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fe31087d8eefb00d7c494e223fe87ec45c717b939b573dfee82d87060451ecf" => :sierra
    sha256 "69d2d6b274c258a6f9098e070709a006ed768d116793b83ff27b691613d063ae" => :el_capitan
    sha256 "119b19fc7b8ef06ecbbab0843ff98d98d225dfdf8d6c67499b19e90aa3b3bd80" => :yosemite
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
