class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.4.tar.gz"
  sha256 "f07a0f343c60f6d07f18fa22d3501f8ca8fcb64d20b96e6a74739af444f66d5c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18a904f98b20943106581fbc60c4e342d930cb38e24fd9959d2fe6d9899bf5ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "6152fb55eafef7f9f5c147ce1e4202980629c73218a64da776a657dd8698bb60"
    sha256 cellar: :any_skip_relocation, catalina:      "f088e16a4534783908e85af3bf399293d0199d2318b9f2f86d8b22245ef419b1"
    sha256 cellar: :any_skip_relocation, mojave:        "25f9e3fe1e9859098bfbbe3992ffc008356d300edfd16231c225732530f9780d"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf --server")
    sleep 1
    assert_match "Bandwidth", pipe_output("#{bin}/iperf --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
