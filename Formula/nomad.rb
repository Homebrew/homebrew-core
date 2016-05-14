require "language/go"

class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad.git",
    :tag => "v0.3.2",
    :revision => "efcd4e822d9e1569187ac649da15610b47167f24"

  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84e58064b2bda80accd7a9ed8ef022b059e24de2cefbec47a6beaab9a51cff0b" => :el_capitan
    sha256 "ed1fcf63a27a7259ffa5b0bf43a97c01a99681f2712c958eb8900904e09b0536" => :yosemite
    sha256 "211e4a482e1bb27bfeea759a893dc012627e0155611e331b91454b74e8d96b19" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git",
        :revision => "c062049c1793b01a3cc3fe786108edabbaf7756b"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "39862d88e853ecc97f45e91c1cdcb1b312c51ea"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/nomad").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/ugorji/go/codec/codecgen" do
      system "go", "install"
    end

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    cd gopath/"src/github.com/hashicorp/nomad" do
      system "make", "dev"
      bin.install "bin/nomad"
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
