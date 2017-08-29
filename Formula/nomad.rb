class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.6.1.tar.gz"
  sha256 "0c81b4f74c034db96f12386115ac5e549113a80a80fb34b7edc31b139ef6bf17"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dfa53c318c8f7ab80748e5298d0cb81b1fb5da7ca8b5d46d512f3860ec0349d" => :sierra
    sha256 "d2189dbd11da53eb65fef9c42fe24f4780b7ef72d7a23f1929a97bc852c62b61" => :el_capitan
    sha256 "858cc0c453b5e87dd5af834816408f445b5075ca25bd305b5190acc46df79c16" => :yosemite
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
