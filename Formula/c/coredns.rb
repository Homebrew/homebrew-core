class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "97fa2dda2fbb7f9756cfe4062a6a70edfe6471f120f980e86326ddce06995a77"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e4cb85034347f4c96bf8383de6a3d5438cb3127d7d184e9b31ac84530e451a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6235fc2882eca8ff0090ca0fcf401f34cc90d6aa0dbcf3efbf64b9bed9065918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7146ce0e7dd70a33f65b483cd3e83524dfe6b8bac913850b5dbbd58b16ab4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba87bb5ba4f32b2eb4c40adecd2a5148ad6f260425252552981b957dcdc4a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d76b4b4c4628e8b470113a7c97b3eac43977c7ddb4eeb3157b82759b1ae161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17868c996d118e5ce635933751b8374a99df9dee46912fcfca28dfd436abbd38"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    spawn bin/"coredns", "-dns.port=#{port}"
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
