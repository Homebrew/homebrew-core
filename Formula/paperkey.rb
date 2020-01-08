class Paperkey < Formula
  desc "Extract just secret information out of OpenPGP secret keys"
  homepage "https://www.jabberwocky.com/software/paperkey/"
  url "https://www.jabberwocky.com/software/paperkey/paperkey-1.6.tar.gz"
  sha256 "a245fd13271a8d2afa03dde979af3a29eb3d4ebb1fbcad4a9b52cf67a27d05f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "12be9f841cfb0d4069be3e461cd5e783ba4ea11195507a13763f90ccc026f31e" => :catalina
    sha256 "894ef3339013be6574f736e316c61cbf54fbc3dcac358df14f1d54b1d7387854" => :mojave
    sha256 "82e49c6aa559a349ce73521a90881acb74a540de03d355ad7461c177d00bb8e8" => :high_sierra
    sha256 "fecd3e866173f93ddd6d89e91f2850d29c10e8edf27bb969a95de581ec382c56" => :sierra
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
