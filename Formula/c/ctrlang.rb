class Ctrlang < Formula
  desc "Türkçe backend web dili"
  homepage "https://github.com/darking053official/CtrLang"
  url "https://github.com/darking053official/CtrLang/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6e8d5c2b2b0295c1120de4930a75654ebefb7bd7ad0f39502bf79a0e5facf472"
  license "GPL-3.0"

  depends_on "make" => :build

  def install
    system "make"
    bin.install "ctrc"
    bin.install_symlink "ctrc" => "ctr"
    doc.install "README.md"
    (share/"ctrlang/ornekler").install Dir["ornekler/*"]
  end

  test do
    assert_match "0.2.0", shell_output("#{bin}/ctrc --surum")
    assert_match "Platform", shell_output("#{bin}/ctrc --platform")
  end
  end
