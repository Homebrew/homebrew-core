class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.2.1.tar.gz"
  sha256 "754ab0a7e28033dbea81308ef424bc7df4d6e2fe31b60cc536b61b51fefbd8fb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cffb79e318b18bb8ffe58ddec42841b7de49ad42c167a421df93758608a78958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6efa4665fb211a816b35f09bcfa864a730c6e4090db7980237fa59a21a3ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c37a56093641d787d93ae9bfe6f703c2cb135426118ea840206b6cf65b6b839"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7175c66a9b8d7b696e90924d5143cd7c4c6f70d3882a2786f3074cc76acd1771"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed94aa9afebab06799f8029472589ceec497c794a787cff72b266485d747e07"
    sha256 cellar: :any_skip_relocation, ventura:       "64ed221535508fd70d50c162cf827e21e3753a831cd806d7a81949f9251503af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b82dd7aea8a7176b9de78654e8fb38b5ea3fac1a68ecf538d5fc8c00cd1ddbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30cab186caf9720f6d1758b086d8df5978ea56022a32ad4367f232ab82c1750e"
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
