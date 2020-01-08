class Envchain < Formula
  desc "Secure your credentials in environment variables"
  homepage "https://github.com/sorah/envchain"
  url "https://github.com/sorah/envchain/archive/v1.0.1.tar.gz"
  sha256 "09af1fe1cfba3719418f90d59c29c081e1f22b38249f0110305b657bd306e9ae"
  head "https://github.com/sorah/envchain.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8658954176e96b463565ea6b5c891b3635622c550ca32efb8ee2e3baec30062" => :catalina
    sha256 "3859bb68db413ee3f421351798082c456fbbb82896ef4ca2cdf439cc9d12fdbe" => :mojave
    sha256 "0d615620e4b69e41aef92971fc1aa9a586be4f75be7813ef73ace103dd182684" => :high_sierra
    sha256 "42419c23d7dd363b9232918f69fa4ea01270b6eb4dc9c4b1c4d5170ff920fda3" => :sierra
    sha256 "4e34971c35ec6a716995a5e8d491970809bb5ce6c5651676f70d757b4044c834" => :el_capitan
    sha256 "1de7c8c17e489b1f832078d3e5c403133accd187f2e666b44bb4da5d1d74f9f7" => :yosemite
    sha256 "97f5160a1a9ec028afbaf25416de61f976ef7d74031a55c0f265d158627d4afd" => :mavericks
  end

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match /envchain version #{version}/, shell_output("#{bin}/envchain 2>&1", 2)
  end
end
