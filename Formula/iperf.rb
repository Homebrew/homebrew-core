class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.0.12.tar.gz"
  sha256 "367f651fb1264b13f6518e41b8a7e08ce3e41b2a1c80e99ff0347561eed32646"

  bottle do
    cellar :any_skip_relocation
    sha256 "01de4f2fb033d82ea4b8871d9a4ac10ab9e750b731c7562404cd351cf36ae4f1" => :mojave
    sha256 "7a29fc4ba28b6045cb312df0970bac0186b13fc981eb36a9d1d3c83d1a3a8a51" => :high_sierra
    sha256 "0a2e1d58baabe619ee38814611f8ed51d58b56340bcdb724b4d1d5181377fbef" => :sierra
    sha256 "32d35b8a77f0b9bf8aba9a7e7c0d0629faab867836ef5496c937284498fa6b4a" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    begin
      server = IO.popen("#{bin}/iperf --server")
      sleep 1
      assert_match "Bandwidth", pipe_output("#{bin}/iperf --client 127.0.0.1 --time 1")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
