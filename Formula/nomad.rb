class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.4.0.tar.gz"
  sha256 "b9098781812b93a77ffdfadecd0d3fc8fd5f73dce4b48cd76495b0124bd8cfe5"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddf91dd519fcc203ef9282aa58e65c16efcc200229092cc958a8b0a7ca029a43" => :el_capitan
    sha256 "042fa34aa9ff782bdabe574e5144ee31418741d2ccb0c02b63dcbd25dc76d1ec" => :yosemite
    sha256 "00fbadc79e816afa0d237d36bd6542abb35b55586099e02e1df3f557b9544eb5" => :mavericks
  end

  devel do
    url "https://github.com/hashicorp/nomad/archive/v0.4.1-rc1.tar.gz"
    version "0.4.1-rc1"
    sha256 "b9883930003283c0dbc0027b273ce5ae745055c542d2fe514befcd4d555d89cb"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      system "go", "build", "-o", bin/"nomad"
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
