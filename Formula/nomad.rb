class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.0.tar.gz"
  sha256 "a7d9126b4ce7937dbf3c72f14172261ddf59e88f4c2e4b7167601ab3ca421059"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56383778c0b8b513c7db6b36c920d405fd135e5c829c8e085c36c00a86e420e5" => :sierra
    sha256 "e66a2add89042671efc5508dc3d55f130c026ba51b8742277e9d6205c9493697" => :el_capitan
    sha256 "f292943027d1ee394312ec6286ef3ef944a6cdcac882b6086801d12eda7864ba" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
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
