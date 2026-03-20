class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "01ba215d9d33a1033718d84f8627d2014a3dcb78be035e37a30a115ee3756a77"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1b994a119dac5ea6a04f9b7cd1eb947c343e6a7086870163ac6cdc6a2389864"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "986f5820a9a95c7a5f486369a513abc38c86d39032f7a745affb862818223973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302b6caa94d2ece1840373a452f880321d1c12ddc4c589477daa1a44961fca9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ee81ec9eb70bf4f3f0c8f132870c696037434f72bea0a83e8fc8633b9cc4102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b12f2773fdf023b9a74a002b86bd54fec92a91c0e1cb48d5ef5d4740fb905cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e5c7872d9f192a9f94259b436fcb8e8db98a69a6d486f9a0bafb0226e24557f"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ab-av1 --version")

    system bin/"ab-av1", "encode", "-i", test_fixtures("test.mp4"), "--crf", "32", "-o", testpath/"test.av1.mp4"
    assert_path_exists testpath/"test.av1.mp4"
  end
end
