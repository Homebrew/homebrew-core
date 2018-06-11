class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.4.tar.gz"
  sha256 "8dfacd578f2be1ae6cc7af6b2749952f1646344cb95bde17f35eeb78faacd616"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca31c4ffe06992ed2e20ae5450b663c295e9996966cee3bdc58c596e06010e12" => :high_sierra
    sha256 "1ce7c627de4b3ea61b05a750cf7264d7cbb6f51b0a6dde9df9a0153dbb013845" => :sierra
    sha256 "86038847277661309c15d6edc9be8f01b02a22af7c866ef227ce7e1a33c8f243" => :el_capitan
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
