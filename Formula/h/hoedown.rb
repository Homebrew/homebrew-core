class Hoedown < Formula
  desc "Secure Markdown processing (a revived fork of Sundown)"
  homepage "https://github.com/hoedown/hoedown"
  url "https://github.com/hoedown/hoedown/archive/refs/tags/3.0.7.tar.gz"
  sha256 "01b6021b1ec329b70687c0d240b12edcaf09c4aa28423ddf344d2bd9056ba920"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "73ef87613d6b099fc9431c878d5b38912eaa0e9d1fa5c60dd6710695e54065e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fb7b81c0d930df8830f4424d2737dfe94320153725066bf2669c24f9cbb9ef46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b1beec1ef5663b3a9f945403dbd5337e1c840faaa6662faf18e39c41c435963"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ad1617812e2acc482387a1fed431b102a43cd3c641f4b639131a451c2608077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c91387f585953da59a7587de33a6085642da3d55a416c6d1a99839340df531f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "748004674d9036262032eda6a9b574137cff8a01178977c45d735adba7160587"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b75fd94f2f468aa5990c8f5383bc71453e2fb96a2280c88043cf7d375b1dd2d"
    sha256 cellar: :any_skip_relocation, ventura:        "141636a2e7dac87d21a6de5d3c31ab258048e641934b6da600b50c79a9b34290"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a6b53be859368f6565a31c918758648fa6c41f833ccd2419961fb3b01ecaa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8878fa04ace3327364bb0d18113bbb56006f169d7f169bc41d03986e1bfe6270"
    sha256 cellar: :any_skip_relocation, catalina:       "578d2db4436012569cd56a47cca8967e106cd83474ed80f52dd7deeda6b1a134"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "09bbf5d61c9d83cd75e37e09ac33cf02b267a99fb6702879bb28e096753d6470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9c93dc9fcdfd9daa56e0dc4c410ec0003a11150b211124bc0c367098fb5132"
  end

  def install
    system "make", "hoedown"
    bin.install "hoedown"
    prefix.install "test"
  end

  test do
    system "perl", "#{prefix}/test/MarkdownTest_1.0.3/MarkdownTest.pl",
                   "--script=#{bin}/hoedown",
                   "--testdir=#{prefix}/test/MarkdownTest_1.0.3/Tests",
                   "--tidy"
  end
end
