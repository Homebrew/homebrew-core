class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "https://loop-aes.sourceforge.net/"
  url "https://loop-aes.sourceforge.net/aespipe/aespipe-v2.4i.tar.bz2"
  sha256 "b41c7aaac2542e59d8ff58c1ff9d87b52d4a8c1847b799c8afec91d94517c75e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://loop-aes.sourceforge.net/aespipe/"
    regex(/href=.*?aespipe[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86bae4aeca9e193fe463440c99bbe947fc476179522d842fb78e656a803afce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33cf76b4cc0d896ed2e642550fca9d0cead87e57db484d3abaccf242bd598397"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "223a7bb4dfc437072680e60971c420fc35894e3b722945b2c6abb06ca142a8a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3d143adfbdda4223863a2987725c57e57d2a74b6625379b193ec11541667cfb"
    sha256 cellar: :any_skip_relocation, ventura:       "16ccce0c36c521aa20a54b3aa450219d1afd242a64f710e27dc674448e9dce75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e4fda06f8e7156dd281dbe7de2598d07208021bcf01e59f2437a4005169caef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e75357d2a1fb758220a6eceafb99b8800ffce2c08fd96a003bcfc96568d0646"
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
