class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https://github.com/magic-wormhole/magic-wormhole.rs"
  url "https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/0.7.4.tar.gz"
  sha256 "3ddc40c82faa381e96ffdc54757625a4707c1bd111d67ab2ec733a5bb666a43c"
  license "EUPL-1.2"
  head "https://github.com/magic-wormhole/magic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c291523fc89958dae120378dbffb0a4e76ba8ec8604031b4df19d08a0a63af5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9343957ebd9870b2a721e4b3f0a0f7374b21392785330dc66acb78967cb5ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d363764193ad93360c2ad444381936c7b28f110f952874fa3277dc23db03e77d"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a239b2e52bc020fb593c186bcfe8bda822fd21984c73b54a3608def96de24f"
    sha256 cellar: :any_skip_relocation, ventura:       "30e96e43a6d388fe42da77457b20ad22831089441cd70dfaa4336c6321363ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91faa7de6700a7a6bcc339412786a9467e65027484a3dce8f2b3047bcc64314f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"wormhole-rs", "completion", base_name: "wormhole-rs")
  end

  test do
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    end
    sleep 1
    begin
      received = "received.svg"
      exec bin/"wormhole-rs", "receive", "--noconfirm", "#{n}-homebrew-test"
      assert_predicate testpath/received, :exist?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
