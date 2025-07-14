class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/52/97/5735503e58d3816b0989955ef9b2df07e4c99b246469bd8b3823a14095da/fonttools-4.58.5.tar.gz"
  sha256 "b2a35b0a19f1837284b3a23dd64fd7761b8911d50911ecd2bdbaf5b2d1b5df9c"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7973303e1a05170e16651a5a5f0dc661074e16c26d12a832a21e47f9ea23b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e1723bf678a25851c3d011fc0a91356a21360d16159d7ea4ef6d8b44d30043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69c075cc29d69850f83b95d353fc53cefab8120172223a7c67ced8446372d509"
    sha256 cellar: :any_skip_relocation, sonoma:        "513303c4e58a041aa261bd20d81e21101482c5f2cf2a7a2b46fc169b7e4166f9"
    sha256 cellar: :any_skip_relocation, ventura:       "a41079da505b5c71642aae63997247ecdd2b0054e1bcf1ec09ed3edbbb937bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464af4550b9d4b5cc8f7e67f44367754a6a706b9897804d3ff7450b6d75353cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2806fce9b3b6c0149ec7024694334e46ab28fb160abf2a7ce97f45cf4a8130ab"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c5/ed/60eb6fa2923602fba988d9ca7c5cdbd7cf25faa795162ed538b527a35411/lxml-6.0.0.tar.gz"
    sha256 "032e65120339d44cdc3efc326c9f660f5f7205f3a535c1fdbf898b29ea01fb72"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
