class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.5.1.tar.gz"
  sha256 "88beeb896b6a1138046f665c3495f85670a74a527e34743080d8976d3f1b73b7"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4e4f752ba34b14b134bc80a67ee0f6f36d74f5cbdf95b88ec306bfade5a075cf"
    sha256 cellar: :any,                 big_sur:       "e71fc42f451a7d7e5d9d7fe61133855e2cab497c96c854dd738f24da3d3818c8"
    sha256 cellar: :any,                 catalina:      "e4c94f149462465d73b0cbf4acae91a6dd9e4566b8c3852a7c96b319e831ca1f"
    sha256 cellar: :any,                 mojave:        "f19277f478fde77637dacca7a4a080294f7ad8109de4568b32acbec00d647ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c56085cbe3eca95c3fc1958a38924283bff2b54c9d5d011d1132cb9c181fce40"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
