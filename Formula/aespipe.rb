class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.io/"
  url "https://loop-aes.sourceforge.io/aespipe/aespipe-v2.4e.tar.bz2"
  sha256 "bad5abb8678c2a6062d22b893171623e0c8e6163b5c1e6e5086e2140e606b93a"

  bottle do
    cellar :any_skip_relocation
    sha256 "abd6ee4463960a4283fa5fd97b45f7ca49400bdee3182d1248ced9ef45626189" => :mojave
    sha256 "0031c9dbcf93fb4faa3b4176491cb0917426f0b5c146e0dff9a1f51a0d2cc9c9" => :high_sierra
    sha256 "7569237a2bd31170d52f161afdb3b46cc23acdc4a35c2662d0b79aac831ac2b8" => :sierra
    sha256 "5a70398747999348647c7577da0c4fb2274413f53ee65fd6fce3845cbc27e0d9" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "thisismysecrethomebrewdonttellitplease"
    msg = "Hello this is Homebrew"
    encrypted = pipe_output("#{bin}/aespipe -P secret", msg)
    decrypted = pipe_output("#{bin}/aespipe -P secret -d", encrypted)
    assert_equal msg, decrypted.gsub(/\x0+$/, "")
  end
end
