class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.2.tar.gz"
  sha256 "6d76955211a9d4d3c8cd37de4dc258ea211a04cd73dc4a2b1dc3844396d02a72"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    sha256 "0aecbdf384c6b3cc80a145d8863787c16e44080181a02817438b84f2e52a604d" => :sierra
    sha256 "3cd1c6103ee289d3cea39a6a5dabd3a8f3a7a1517503a2ba3161ffc43577bb81" => :el_capitan
    sha256 "869acfecea68003dfcb3969b25a35e5b7f9ddf31708c82fb4c43cf38118bf0bb" => :yosemite
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
