class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f123daba18f0b4d6f4623c618a8c8a8ffc27c4805bed903c8c4726e7f32c0488"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db4458dd42e5d0db1ed75f20117cb38ef5f8b54d6d49d32c663776eb0effd738"
    sha256 cellar: :any,                 arm64_sequoia: "6393915dc453bd36e87a6cac6fee4c66253c85fd15581781a6e436b8e811f2d9"
    sha256 cellar: :any,                 arm64_sonoma:  "e6a3ce8cc7c3ceebd7b17163d2b0494848910dabec70fe9e39aad44935e6522e"
    sha256 cellar: :any,                 sonoma:        "6c1cff1dad195fd9d67e0313a7c24f6716fd733f3f2144f1353c2e5226ec308c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d408b8414b7c1175320b7af637a675cbc538f38747b717ad37121644458d8dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927248a05f0707d6020de2dbf3a03107159a250d5b69be176a550c2d5f1fc5e8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
