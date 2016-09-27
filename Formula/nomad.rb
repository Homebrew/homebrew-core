class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.4.1.tar.gz"
  sha256 "1156ddfa6542ab865b987456cbead90edf6eadf68881a557c777ab69745c9b54"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e643b9026ed2ada8ac50b218ec08e375a558400b8211c8a922f268327859aa2" => :sierra
    sha256 "8d373ebe65d9db5bfeedb09ad5b3a22ae554932b7dfc850a892c60d8838a6d42" => :el_capitan
    sha256 "ba6a47c30fdc5f9327cbddc37151826ac43086fc0ebabc5af55edbe1d4f035c8" => :yosemite
    sha256 "ece20f5a7cd1ade4b346f1b12e0d29f1f737deec31a6600cc5aa2d70634154ac" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
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
