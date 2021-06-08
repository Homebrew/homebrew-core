class Gollum < Formula
  desc "Go n:m message multiplexer"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/0.6.0.tar.gz"
  sha256 "2d9e7539342ccf5dabb272bbba8223d279a256c0901e4a27d858488dd4343c49"
  license "Apache-2.0"
  head "https://github.com/trivago/gollum.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5ee2cb96a94ee53e89242b117564bd62236193f1a32ed0a54658ecd1c31a0a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6d6cfa922dc4fab92280d6b608f73ed620b9042c16c2394ea28d439d7360db4"
    sha256 cellar: :any_skip_relocation, catalina:      "bf987d3c10c67153ffc11b1926162882d00cdf23261516e614181dafb67eb70c"
    sha256 cellar: :any_skip_relocation, mojave:        "d2d022b779e4290e98d0783232b00c79bf46fc08d9ad3bea0dd352071e2995f3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "afaf112d706150eeb5f8e5152a7b88ef18fc944fdd01dc8a46357a3c8ce13f8b"
    sha256 cellar: :any_skip_relocation, sierra:        "9e82aadccabe2a1224658cc824536e061d617355bb7f7eda5a889e117c3bb472"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w -X gollum/core.versionString=#{version}")
  end

  test do
    (testpath/"test.conf").write <<~EOS
      "Profiler":
          Type: "consumer.Profiler"
          Runs: 100000
          Batches: 100
          Characters: "abcdefghijklmnopqrstuvwxyz .,!;:-_"
          Message: "%256s"
          Streams: "profile"
          KeepRunning: false
          ModulatorRoutines: 0

      "Benchmark":
          Type: "producer.Benchmark"
          Streams: "profile"
    EOS
    assert_match "Config OK.", shell_output("#{bin}/gollum -tc #{testpath}/test.conf")
  end
end
