class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "c68c05c0d87d4ab1069196f339043252fb1754395d8e5504f5295a2fadcc51d2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e4917f542d704ef5cdf633a97965c47da8df005eb1de25e3011e6e994c92beb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020d62bdfffa328ad56c61265e5f1e746d50226ea0cf3cb71ad82b2690b16784"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d208f0eb4156b69c483bee88f4d990ad4cfe775b0a02806107aa85559ba30d6b"
    sha256 cellar: :any_skip_relocation, ventura:        "9279d00bbca276f33903ef071a7a104dfe5807ab606c0ad7809ad12b8e2544e9"
    sha256 cellar: :any_skip_relocation, monterey:       "75700c74437df0a6502202d096c6dd72acaedaddcda293d6e65c4e1a335b239c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db62cca30d2873265f11c5cca3b9c8e8aea92d88ee72d79845956366ce00993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ef81b9929e5fb390cda4a777ab0d5897e7e60c6ad462781623e20ca50e42d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
