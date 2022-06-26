class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.4.tar.gz"
  sha256 "172c413709dc81ced9dfa2750aaa398864e904d1ed213bd19e51d45d1ff0a8ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c87900965e5e508b6396358f50efdc787cdff1a2acc25675015ff2455f880be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8eb2c951c880edf5e91608c490c4bfd89e20c8c4cb03b9c55a2855ff0a2ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "116af084ee4a7c6200245b311b140a7e6bb73ee4a71cc15fb810e2473b1c1027"
    sha256 cellar: :any_skip_relocation, big_sur:        "94314148a176b42e8dfbc65d5a5c054db400dc3b9e9a7db30f4aff960dcd01b0"
    sha256 cellar: :any_skip_relocation, catalina:       "db968888625e57bb1c434e5b4021c9126adb42ea042906bb00df6e95dad2223e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f90326964f0e22dae498a84ecd100986fbb6ca343b215fe33355e6a5f46c89ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
