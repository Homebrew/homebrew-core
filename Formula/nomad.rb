class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.7.1.tar.gz"
  sha256 "312b7d89b0d03154b9c84672f013ff0d9c44dda0a73a8187d5509088fe0051c0"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2840432b1bb4f5e33958ed65d34dd08e66e14fcb7cb6b4d4abe17fb6c130895c" => :high_sierra
    sha256 "be756f01570d805e9c310384a8ae410d4d45e89314920ee868b14a6e9684f294" => :sierra
    sha256 "529fa59fa3db8507a57282bf85c4f0625b01c42c93b95a8fb655b7654431f667" => :el_capitan
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
