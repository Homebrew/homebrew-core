class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.net/"
  url "https://loop-aes.sourceforge.net/aespipe/aespipe-v2.4h.tar.bz2"
  sha256 "eab311fc26ea43289bc3adf660d6270492494960725d2026ec4917294a1aba49"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://loop-aes.sourceforge.net/aespipe/"
    regex(/href=.*?aespipe[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a494b4fdf2eaee8c7c18d3c1b0bd0556763f7bfa10038730fe57b0848ab6ae32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5c732916f232fc66c66042ea3e3e56fbaad0f6180079688318983671f2d0b2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae9d4bf8be495b08719db9ce0b76e4cca4c633fc42e3c858c2034e3dc380d0b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f02f0acc25dd503fb39b2497f3c7fc62cf9b920f9525dfabc9e6f17f5585453"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b19f156c0042ebe13e25ab302c4a6e49a57b7806317661a87348b4b071f6c58"
    sha256 cellar: :any_skip_relocation, ventura:        "151c9bd206f7b2c720436867f75b543ebb037e3844124ae5e86a726945cf51e3"
    sha256 cellar: :any_skip_relocation, monterey:       "dff5d59e8ee2b457642e710e267a26157f41a1ed567cf3cc5c012aa62e1e72b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b16cb6c0e9177020073efa7fc9e94df35df98e00a9724b52f69af90cdd66374"
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
