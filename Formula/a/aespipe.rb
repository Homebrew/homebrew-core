class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.net/"
  url "https://loop-aes.sourceforge.net/aespipe/aespipe-v2.4g.tar.bz2"
  sha256 "bfb97e7de161e8d7ce113b163bda1d1a8ec77d2c1afab56dcc8153d7a90187fc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://loop-aes.sourceforge.net/aespipe/"
    regex(/href=.*?aespipe[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40c2c108b9af80459022740d9ab1dba9829d02f690da4806bf72d81ee865da58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7277d8d08b30057357e1b4a9d46f6695773c5bbac3e545ffb00a8578736c6148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf2f7af4672b1f12aa21297624bb0688529be30c99bcf9ed6431652221370e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c2e21eab82bca6f64ded46b5efaf95c16a28f62e8c26597c64b2e39f5211ea9"
    sha256 cellar: :any_skip_relocation, ventura:        "03e4c7d995988175b5d4d4ef5ae7c44ded67d1ded3f35456f8b7af87d97edadc"
    sha256 cellar: :any_skip_relocation, monterey:       "099142fa7fd621c86caa12a7e71a7a9a07e7d697d9a2e53f28e9bf2abf0f6653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ee6b5d90d8f14a86a7771c996e50ddcb3f17d586aa3ea04379a8cc2c21b9c8"
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
