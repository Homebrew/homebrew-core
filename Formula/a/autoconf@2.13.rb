class AutoconfAT213 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftpmirror.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
  sha256 "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f5871980126b7e1f4135fbbdc0d00932c4c670de6f7b1e095698d3c326e5c4b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa08a57e3bbd841ad5085216fde02726a26379c2ba53dd46e849dfe49f02cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8ff0982e2d5057b15802e26a9bfb14144f42d4d59683ea9233de0348309298e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8ff0982e2d5057b15802e26a9bfb14144f42d4d59683ea9233de0348309298e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "075de1fe7d7cdf38d3ca84a4436a8f9839adc333e3eb42ccc21c15d77cf01fb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "286b0faa90ffe785542aa8effd23c1e75b404590ded0e3166d759577eabc904d"
    sha256 cellar: :any_skip_relocation, ventura:        "c8091905cf2e72b925e7ab60a776a3d6acb6e6ab01217e396055e7f36dcc15ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ca413d4515dfd932453a20978e21f95ce349421052428b547ae938c60792a76f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d538d7301ae68a526aca1848ed4bab6fed48ee6b9375766b26d38fa2825a1c0"
    sha256 cellar: :any_skip_relocation, catalina:       "d3b4d6e06ae6749fc60fa437f1f5c2ae85a91f6979ca897e08b854f920c222a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cccd5c06cf43a458be6dd0f07af79a3d63411aa6e3c350df0aae1e9a0b6b795"
  end

  deprecate! date: "2024-02-22", because: :unsupported
  disable! date: "2025-02-24", because: :unsupported

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-suffix=213",
                          "--prefix=#{prefix}",
                          "--infodir=#{pkgshare}/info",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match "Usage: autoconf", shell_output("#{bin}/autoconf213 --help 2>&1")
  end
end
