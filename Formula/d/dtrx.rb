class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/b7/e6/204294b57be7bb5072c217a1c3ddd5acf9b60b006c215e13e11121c04108/dtrx-8.5.3.tar.gz"
  sha256 "eec67869b85068fac8406f5018d781aee5b55422f3b7698bfea43468b2cec67c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3ed9145d7343c6ae56e052ad0b8c3e369290fe84668dde3f6658d1b3ffb6b9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1736cb60f34a0ab94077e3a6981d03d9a533fcdf67cec3b047579b87a606b2db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f5c7f156466e498729c08b514d71653924a8e80608c25d834d6c19af38d6be3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6afd2b7089bcc4778cdcc0785ee5aeec4bfa7e3f1f325823185873e993ba7cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "783fe0f14c66dc81c9accfc0bcd704c8a85c458f7d05a69e232f33e9b4394797"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fded854c8e5a0b8d88aecb86d19f2ddda36cdce49150fedcf6e3d4d491f0bc4"
    sha256 cellar: :any_skip_relocation, ventura:        "174026128d9cffc6f70bf3bf8fd8a791eca1d1840cf8d39fc586219962786954"
    sha256 cellar: :any_skip_relocation, monterey:       "4be0c1b639312098dbab1cd7031d7e13c4586bcf99040676fdb0a902ced1d29f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c539cceb534dfaea15540170888aeee11c57159a56214baa7cbceb1a51282f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c72291b1ac4380ff4a2bb6036d05c8fcbc318015b0b5301b2208674c72e3ab"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system bin/"dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
