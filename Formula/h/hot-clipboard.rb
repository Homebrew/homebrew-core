class HotClipboard < Formula
  desc "Ergonomic macOS clipboard CLI bridging terminal and NSPasteboard"
  homepage "https://github.com/Whatfck/hot-clipboard"
  url "https://github.com/Whatfck/hot-clipboard/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "394f17104530efe0fbec391664ae3341fcc2fe0f2d990807001f8f57a0b70970"
  license "MIT"
  head "https://github.com/Whatfck/hot-clipboard.git", branch: "develop"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Hot Copy", shell_output("#{bin}/hc --help")
    assert_match "Hot Paste", shell_output("#{bin}/hp --help")
    assert_predicate testpath/"hc", :exist?
  end
end
