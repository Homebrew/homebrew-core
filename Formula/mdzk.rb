class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk.app/"
  url "https://github.com/mdzk-rs/mdzk/archive/0.5.1.tar.gz"
  sha256 "347f52b6fc221d3b3692c311afe4dbf55adcccb225be97a05c50928a0942cf3f"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9288d988b58e3a09156cff206afd781073b2943ea6de9599c3f4c1c483e418b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d2cf9f2f5d2b04ad8ebe5ef5f65db46b938fd4028c2213d27731571c624d62"
    sha256 cellar: :any_skip_relocation, monterey:       "c653ba3004e0b893da802d975ec5fd0ecce3f739b7c0e2b8aa8a7dc85103cf98"
    sha256 cellar: :any_skip_relocation, big_sur:        "a50d50d965e58efd99aaa31c812603152f2ca6f1acc4c2679790ad31bfcc87c6"
    sha256 cellar: :any_skip_relocation, catalina:       "7f7474c339203d8b42041f14c1080f074b9a5a00f06b7673ec7bc8bf2f1c02ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e5e00bff6fdeda9bea9fbf6507f6d028e2da51ee27154c87e493109cd5b2d7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
