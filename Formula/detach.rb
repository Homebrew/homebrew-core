class Detach < Formula
  desc "Execute given command in detached process"
  homepage "http://inglorion.net/software/detach/"
  url "http://inglorion.net/download/detach-0.2.3.tar.bz2"
  sha256 "b2070e708d4fe3a84197e2a68f25e477dba3c2d8b1f9ce568f70fc8b8e8a30f0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbd06a1dcb4592035dff0b4df0cc3259c2dbb444acdb1553ab2a2d4edf3fff57" => :catalina
    sha256 "4aa3f65488ee7fb05d156d92f5f76a29d2cebe2034b226665e219978e228f1db" => :mojave
    sha256 "3367f32cb05a37e05e9ab18e4e1f2664137f7d03073fc2d9ec4aba0d62a6f431" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "detach"
    man1.install "detach.1"
  end

  test do
    system "#{bin}/detach", "-p", "#{testpath}/pid", "sh", "-c", "sleep 10"
    pid = (testpath/"pid").read.to_i
    ppid = shell_output("ps -p #{pid} -o ppid=").to_i
    assert_equal 1, ppid
    Process.kill "TERM", pid
  end
end
