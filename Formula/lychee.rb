class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.9.0.tar.gz"
  sha256 "2369612c691b814d6b34c0fc8dae5a7474c95368c10a1ebf9266784c27f32fb2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "366e9cf8234941a2d8dd6a4700d9361fdcc37a7d820fc77d9b50c7f0aba47c18"
    sha256 cellar: :any,                 arm64_big_sur:  "fd4ca60efd423280cc5c7545f83fedf74dddecdb45ff3ba04bfe52b6a7ef9e96"
    sha256 cellar: :any,                 monterey:       "5350efc90a0635c7fd28123124d1e1a154a3c4184c8ae1d14ca55eb2b3b1e1cf"
    sha256 cellar: :any,                 big_sur:        "8b1ff6033fd70cdcb879e62ef116b30a7c4f3034156a7ef33262cd60dc0c913d"
    sha256 cellar: :any,                 catalina:       "2a5469d41279cfe5668c55708faba679e3b235b5afe6a10ca7d007d910484ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ddd80d247313bf9e454806e23dab1481f6323175087c752389273ec40652fb0"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 1 OK 🚫 0 Errors", output
  end
end
