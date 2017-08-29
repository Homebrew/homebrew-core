class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.6.2.tar.gz"
  sha256 "091d95e744f99139f4b4f2ca61394b45aa44cb7ee45f62958614767e43f61158"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffea89b220d35b51d8ab2ba0f432a32a2f7e4dfc0d422634c2566c88a92e6ff6" => :sierra
    sha256 "fb4907ac0fb8e9e18e5e64c5a17324833c46893ca1f7a03f94aa77708d0a1f0b" => :el_capitan
    sha256 "14c8af70637d3328737e17069f5393672547c860125fc0dce17a23c66985b4f7" => :yosemite
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
