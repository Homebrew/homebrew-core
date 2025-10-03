class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.net/"
  url "https://loop-aes.sourceforge.net/aespipe/aespipe-v2.4j.tar.bz2"
  sha256 "448fe1e58612c184951645ddd926fc5bdb64fc4f2f828c766c82aa1127e9a3e2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://loop-aes.sourceforge.net/aespipe/"
    regex(/href=.*?aespipe[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc60a58b6bd7edc3b66eb41f00db8c6b5cd875ba16451ea1d17cb760e3f9240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30d621d103de66d7f34cb29a9b75022c1074d510880d7e953062569a6411c9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ca22c2423a32c3060e7a0bff95254c3051fd3a6af36e110620b28d1426bf5c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0e76b53b8dff2ff1f1141f2c8ba3f1f779019d92ffdd3c18be26850cf60176d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4af99e0b662569c6d8c11affab727184530d174f3837d209661c59c7d11ff008"
    sha256 cellar: :any_skip_relocation, ventura:       "0839eb2b3920448d08700403bde7c9ce6c7e6f1c01f0082763e1aa0513c00c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fa15737620b958cfcd6333d49e868b26d72e4cf6f7908b7129bfcb2b5c5c3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b78adabc6a957ed1ff8947cda33e32704dcc0104149a0347fcfd735d7ff91b78"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "thisismysecrethomebrewdonttellitplease"
    msg = "Hello this is Homebrew"
    encrypted = pipe_output("#{bin}/aespipe -P secret", msg, 0)
    decrypted = pipe_output("#{bin}/aespipe -P secret -d", encrypted, 0)
    assert_equal msg, decrypted.gsub(/\x0+$/, "")
  end
end
