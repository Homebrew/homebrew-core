class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.7.0.tar.gz"
  sha256 "263e7e4fa3456929cc64eacd2ab01a2241fd10dd197a61f46dbaff2e7479b96b"

  bottle do
    sha256 "4783cd85835535740035cbc4e3a4d33d9ea9d78b7e9f1cab71683206df1fbb26" => :mojave
    sha256 "bacad4154383fc68ff5997c8d37a079809c89d27b2db197b05eb95ad988d9e47" => :high_sierra
    sha256 "bddb9deddc89b053416f1c9d93cf72620b0ca44b410469db645ec697b219b6a6" => :sierra
    sha256 "583b188a012c1e59b2f7157d35c24178c6a0f234166d2730f0bc9e4a8a0d266d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
