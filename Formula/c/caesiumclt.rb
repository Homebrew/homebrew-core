class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c170c4d1ab1179b3757ec39f00c08250b121195e07f013fcbf9f3952db333a05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbbbca303b22e31fcae389175956254df7de406501a049d2cac32f6d8ba7a3e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c81c69ecc28f62ada9b8f796d68834be3c6f55b6aa0267384e3851ccb984de2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cb517afb1b0438e38bbd0cc417cdd3f1b75fac6211e98b809cb11f040e9a08c"
    sha256 cellar: :any,                 arm64_linux:       "a5d1ec3ca2808c608a3b6e4f7c2a8aac9b859d274a35bc17cc917b1ca26d67e7"
    sha256 cellar: :any,                 x86_64_linux:      "d76dd7f083ab897f20b31d7072fdead75f572ed2169b758366eb99317a47760a"
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
