class Bk < Formula
  desc "Terminal EPUB Reader"
  homepage "https://github.com/aeosynth/bk"
  url "https://github.com/aeosynth/bk/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c9c54fa2cd60f3ca0576cab8bdd95b74da4d80c109eb91b5426e7ee0575b54f1"
  license "MIT"
  head "https://github.com/aeosynth/bk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83888caacb2e9c2a3f168143958b4dc5d8398ed8372cfa30187780bac498d376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7800246f87267b642a3c4c4cccd4363a26f58db3245bcdde0dd9c161a6a0ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "9c45def155516544d952e060e78b44c3e9973f5e90cd25828029133d48fbcfba"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0e03c86b30c329f2b77d7436d154c365588acdacdcf1681e1370f13302cdfc2"
    sha256 cellar: :any_skip_relocation, catalina:       "2ffc3317ecb58f4e22c832a674e64b972cadcfc7e30a3598a820187fe90eb4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a7201991a14e455d5912fe064b0a34db4882c0054e7f2094a00e11aaff3e16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_epub = test_fixtures("test.epub")
    output = pipe_output("#{bin}/bk --meta #{test_epub}")
    assert_match "language: en", output
  end
end
