class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "http://www.jabberwocky.com/software/paperkey/"
  url "http://www.jabberwocky.com/software/paperkey/paperkey-1.5.tar.gz"
  sha256 "c4737943083ce92e41faf13c27a9d608105b6285c0840dfb684a7ee294142ddf"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bec14c3466ebbfed0b3274e7b0a4ec1fad3250def1f8042596ec47039ce35e6" => :high_sierra
    sha256 "124e141330feb1837f2c282084f0b651118fc8f3e881246ef19004e2e636f640" => :sierra
    sha256 "0fa35d8d6b75a8bfa74b4b81b3f180bf76a64b5c987fd1f46e64d36473c6754e" => :el_capitan
    sha256 "456397338a1d99f8559f9b071c2d7856976a6308535237e463f020264d5061e2" => :yosemite
  end

  resource "secret.gpg" do
    url "https://gist.github.com/bfontaine/5b0e3efa97e2dc42a970/raw/915e802578339ddde2967de541ed65cb76cd14b9/secret.gpg"
    sha256 "eec8f32a401d1077feb19ea4b8e1816feeac02b9bfe6bd09e75c9985ff740890"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    resource("secret.gpg").stage do
      system "#{bin}/paperkey", "--secret-key", "secret.gpg", "--output", "test"
      assert_predicate Pathname.pwd/"test", :exist?
    end
  end
end
