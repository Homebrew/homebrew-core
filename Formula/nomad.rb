class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.5.tar.gz"
  sha256 "250c2bbd06ebfb03a8fe747455855af02e3f318724ba01762ab609e4ae600097"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1521d32caba2445e65bb48971d88f1bbb69130b3ae0957cc2a4797145447ab38" => :sierra
    sha256 "8cc14873c8bba26a31503f34676ccda41e3903753d832905abfce930f8181421" => :el_capitan
    sha256 "03d6c9508ad5438189c8391fec416b2136790e3b3fb0a3e19d1d4b4deab7f9e1" => :yosemite
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
