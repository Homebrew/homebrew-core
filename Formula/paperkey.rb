class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "http://www.jabberwocky.com/software/paperkey/"
  url "http://www.jabberwocky.com/software/paperkey/paperkey-1.5.tar.gz"
  sha256 "c4737943083ce92e41faf13c27a9d608105b6285c0840dfb684a7ee294142ddf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a541e2c254870a1e53049a478dd7067537a7d3e9ededad8123fd7d9f7c48f576" => :high_sierra
    sha256 "9c96b3110a0af3abb54d19f6fb73b60bbcf1868e5343ba69fde37d7abbd5714c" => :sierra
    sha256 "e98cb1a1b43ec005129d6346a7d6df00bcc50ce12366bb741581f448f9321d59" => :el_capitan
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
