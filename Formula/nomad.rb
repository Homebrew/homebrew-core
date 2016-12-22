class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.1.tar.gz"
  sha256 "7bbd5f8c23affb3c1b70d1c8fda22271b6ef7941fed938f79e94fce27139e7b6"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18497028c53875a758ac09f41a3e74b82f422428a31279c626fec1704dab1acf" => :sierra
    sha256 "3110b876f574cab2ae5fa202998615e3af369f873d5ace8fe3129664599cf9dd" => :el_capitan
    sha256 "7efa378b6ac4f2b9f83e36b0cc71faecd07554a09d932c5f44e638b74ce70c9d" => :yosemite
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
