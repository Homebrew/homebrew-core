class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "https://www.jabberwocky.com/software/paperkey/"
  url "https://www.jabberwocky.com/software/paperkey/paperkey-1.6.tar.gz"
  sha256 "a245fd13271a8d2afa03dde979af3a29eb3d4ebb1fbcad4a9b52cf67a27d05f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6d8cc4b86c7a9a5f7185cb8113aed57670c1754701dc2afb6f419775dda29a1" => :mojave
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
