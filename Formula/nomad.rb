class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.9.6.tar.gz"
  sha256 "c37e03cbe939ddb983307e3eb501b83e025e2c915de312094384db9164ae7a05"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbc2e2ba1aa8d1cb8f7e913d15407c72017ce8336b09e11ae3ba158f88d7cd54" => :mojave
    sha256 "5a11ee1e498e435e6eb30a3c9fd87efb1a62899ca3da0e392877d5b6f0af2e15" => :high_sierra
    sha256 "81a87661a1c1960763a0a03f7793c89a62a64bae9c793ec0e96fb30f99efbba0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/hashicorp/nomad"
    src.install buildpath.children
    src.cd do
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
