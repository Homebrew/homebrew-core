class Macbee < Formula
  desc "Update all apps on macOS — Sparkle, Homebrew Casks, Mac App Store"
  homepage "https://github.com/yakushevhk/OpenMacUpdate"
  url "https://github.com/yakushevhk/OpenMacUpdate/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ad0b1fac1d04f15a53719c1e49082fdc5da5ad4ecad7986c2cc76350d5c17007"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match "OpenMacUpdate", shell_output("#{bin}/macbee --help")
  end
end
