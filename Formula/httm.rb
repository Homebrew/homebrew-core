class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.28.6.tar.gz"
  sha256 "55476859ae5d2683d735718f958e734d7f2026e4fc145c61a68571a838c701fc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b102a16c344a1ce91bc06d97d2a711a48c1a92a39d9d36bba7792dd21dd3f44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a63d8bd49da862ac311ecf338ce4c3dbd41e9ab95a63494b9d05516a807ecf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "175055859736ca74ff4e87a591004347a9ff2111b2f777f20458fa92aa4d8cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "384b983529dee326fef0f09977837908b8b269577f866a9f5df8cbcaca026f38"
    sha256 cellar: :any_skip_relocation, monterey:       "08054b29b90760f61ea60bee7e7c1a50df9a8fdbf627f67c62b8291029cefdb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e0a98855e4487e110363e9f70815647862430bd9b0181a6616f7c6236dc8b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0bf515fc27b28afc1a4503e28f0a25f191ae367345fd365bc22dcb53a286d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
