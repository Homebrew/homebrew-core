class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.3.tar.gz"
  sha256 "f536e2b798d1731f2bc3575c4c2283a25a02e092d22ea6a25c3c3a6a84564bac"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67f00244823dc82399e3f8e81313c7a4c12cc4d22991feb0737fb59cd130bf07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bddee07ec4de319e79fc9bf3ed915e81f95125eb55d8e5cfaa207cbf0ede8ba"
    sha256 cellar: :any_skip_relocation, monterey:       "3006b3e0f9d29ce1070ad35088af491854f2863ae2d6e6f9e679a99c00bd1418"
    sha256 cellar: :any_skip_relocation, big_sur:        "40db1b24a5ad785386acfe77fc03a5fede21a7439f0380c669d8cc3d00bb524c"
    sha256 cellar: :any_skip_relocation, catalina:       "18fc00864e4e96bf493f0586aea7147bf07f1e880277169d03a0e960f733776b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e813b388548deb952c714d75847ae9a9ecd2bfb3a219a3a0fdfcf6fdcb2c8675"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
