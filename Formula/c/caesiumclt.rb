class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "f51ab9bed552b4010e94ccd9ee96fbc336c60fda906a01f9f039d82eee726510"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "310796aeaaa3d9d6b30bbbf31b4ae3d4001aa55bbf948ef61e3969550599d307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6573ff467a312a82d687894daa89410c31ddf329cb7379d3da5fdaf8da0c8e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ee4f99036740e7fef356b1cbbfef4c08433f1007f8ae2655d6f1c877519d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "776409d7e13de180f3aab60cf6eeededff57fdfedd8201aef7ac42b66dc5e0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee097bf4baf0f1a9080f287cfca0cc773dd35fd5c6a14c6f5cf6759cf8491fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf9347be3943169663949cc96613942ed56a7ff4ac73cb8680f54917533b1454"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"caesiumclt", "--lossless", "-Q", "--suffix", "_t", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_t.jpg"
    system bin/"caesiumclt", "-q", "80", "-Q", "--suffix", "_b", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_b.jpg"
  end
end
