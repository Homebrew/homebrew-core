class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.6.1.tar.gz"
  sha256 "522db57161bb7df10feb4b0ca8dec912186f24a0974647dc4fccdd8f70649f96"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d38edab7ed408bd27e9e9f1885a652c9d142991afee79fe1bdf1d049b906280c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f706e6c204c714e3fc0656cc6807df5147ab772949bbe9f714b6b7385f420fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71a0c12ddcadfcc5ba1b9b9efda2bd5c84f02fc795d7b9ba9a2fae9cdf344d33"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dd2f502fd16e23076d234dce9893b55225bc37b4dc789cd4e69a1b505b11fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "d5604c8b0d336a96aafd97d18e2e2604ab7ec6653685980bc1c467b934a8cb26"
    sha256 cellar: :any_skip_relocation, monterey:       "6b3c15888e1b07d1122d0d6127cce866b7943656ac8598dc54ed4b92131d271d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712436bf59d66a6463ee06711903b120f00d6b16e822fae4dbac203bd083a439"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    end
    sleep 1
    begin
      received = "received.svg"
      exec bin/"wormhole-rs", "receive", "--noconfirm", "--rename=#{received}", "#{n}-homebrew-test"
      assert_predicate testpath/received, :exist?
    ensure
      Process.wait(pid)
    end
  end
end
