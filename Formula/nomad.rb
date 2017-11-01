class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.7.0.tar.gz"
  sha256 "f143fa34a0bad8ede1c2880680db52aed6feb7f8fbd92294b73b6e9ccb1b0376"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f9f8533e39e18d5e0f641e691293feed8e173e42628123df923389ad2c88b24" => :high_sierra
    sha256 "6cba1421c26d925c54a466903f8a39643dfd36236b9d12d8fde7bc9916431c16" => :sierra
    sha256 "d30034b50380089d8332199e9fbf512a99d7f95f29b613f876d6f034f75f70b0" => :el_capitan
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
