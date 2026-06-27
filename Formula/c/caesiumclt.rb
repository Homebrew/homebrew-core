class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9b0417f00ae7fa8fa963ce1435abf3c3ab259bb8e770e13f83a82b66e153f4f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3152fd5fc87211130c82a61d508a0bffa20e9e3bec67c3e502fa73e235606465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee9971b68bbcc8a220fd001967bf0c77537bec53b5b8d24445353e41302bf70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f343bee4be468bc8f566f78499a570238be77c62b7a033cbf0763e07f5537484"
    sha256 cellar: :any_skip_relocation, sonoma:        "781d9229dc1795a7698dd996c81a9cd59b0ad06dc3923276c5501d95a6ac5eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c459d4fb32f23f756e8f4b8288bafb1871fc0db69f9b46f40b6e25a47412cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb9191cecd9a876d2239ab50af367e0b4278005aee4da60a8feadd800df480c"
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
