class Ccextractor < Formula
  desc "Tool for extracting closed captions from video files"
  homepage "https://www.ccextractor.org"
  url "https://github.com/CCExtractor/ccextractor/archive/refs/tags/v0.96.5.tar.gz"
  sha256 "821614d7b31d47bf3bf6217a66464b826c0f86d2bcde070b6fba74f54dff55ff"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f640d9cd318188c14097436f5206c5a0854dc6d39aa668474b45284bdbeed0ab"
    sha256 cellar: :any,                 arm64_sequoia: "a8c3f93fe37be67cd3e716d6d121d50800106f4855d13baaeee28bae8742cbd7"
    sha256 cellar: :any,                 arm64_sonoma:  "f026f821a560198bf26aa1f68997db6254dc21f5639ec00b430bd329e7938978"
    sha256 cellar: :any,                 sonoma:        "528159cd5633d3b2f74809871ec205e98ac9fab621f403022a283e8c7d5ce1d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fee597d0a65901487b2b0ab7ddc1fa7807013ec1db8ba301a0ed72e30e1847dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36941b509ab4fefce7a9bd0a3392cd7a625880b5dce0a20b4d3342395be4bd56"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "utf8proc"

  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
    depends_on "leptonica"
    depends_on "tesseract"
  end

  def install
    if OS.mac?
      cd "mac" do
        system "./build.command", "-system-libs"
        bin.install "ccextractor"
      end
    else
      cd "linux" do
        system "./build", "-system-libs"
        bin.install "ccextractor"
      end
    end
  end

  test do
    assert_match "CCExtractor", shell_output("#{bin}/ccextractor --version")
  end
end
