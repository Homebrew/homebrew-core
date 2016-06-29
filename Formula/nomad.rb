class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.4.0.tar.gz"
  sha256 "b9098781812b93a77ffdfadecd0d3fc8fd5f73dce4b48cd76495b0124bd8cfe5"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84e58064b2bda80accd7a9ed8ef022b059e24de2cefbec47a6beaab9a51cff0b" => :el_capitan
    sha256 "ed1fcf63a27a7259ffa5b0bf43a97c01a99681f2712c958eb8900904e09b0536" => :yosemite
    sha256 "211e4a482e1bb27bfeea759a893dc012627e0155611e331b91454b74e8d96b19" => :mavericks
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
