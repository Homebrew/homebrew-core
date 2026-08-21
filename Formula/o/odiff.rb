class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "4b78712394c0f628331a21086615eadb6853d28a30d4dfa188b12d823d3ccec0"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ce73c55f0cf7f612a7bb65d21ea20d5cac2312887a7fc228b7053113cacb37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e188cd66caee072bd69b70963159d00b7bab0ca9b26dc1561a23269ec24d19a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1467a78d8681c9ec7abbd009191d183309edaddd90092a5a00b832b9eba1452f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56774c83765436fbd8e02dabbf848218cfbf37cb62f18ac9e77506f7096d5a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "803be1d4137c9a355c2b407992137b28236312df82da73f700a4215fd8e0b440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f299ec05e2924d034d823ce94bad32c4563cd4531fd6743d961ab19084153d63"
  end

  depends_on "zig" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odiff --version 2>&1")

    assert_match "Images are identical",
      shell_output("#{bin}/odiff #{test_fixtures("test.png")} #{test_fixtures("test.png")} 2>&1")
  end
end
