class MoonBuggy < Formula
  desc "Drive some car across the moon"
  homepage "https://www.seehuhn.de/programs/moon-buggy"
  url "https://www.seehuhn.de/programs/moon-buggy/moon-buggy-1.1.0.tar.gz"
  sha256 "259ae6e7b1838c40532af5c0f20cd7c6173cd5c552ede408114064475bcfc5b6"
  license any_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]

  # Upstream uses a similar version format for stable and unstable versions
  # (e.g. 1.0 is stable but 1.0.51 is experimental), so this identifies stable
  # versions by looking for the trailing `stable version` annotation.
  livecheck do
    url :homepage
    regex(/href=.*?moon[._-]buggy[._-]v?(\d+(?:\.\d+)+)\.t.*[^<]+?stable\s+version/im)
  end

  bottle do
    sha256 arm64_tahoe:   "53f6259b504aa18f7ee6f00e8609de83f5dcaf145f271223c1b84097d03ee187"
    sha256 arm64_sequoia: "b3e325dda761378e3fb26ff514d1cdf7e2e93b3348d965320de0c73e2726ecc2"
    sha256 arm64_sonoma:  "59629a2750ee206aa53f63466b1abe0b883bfcb5c1311bae15ed503bc205f52a"
    sha256 sonoma:        "6355ad12387367fa817191a32b60cee9f661fdec974867a3b5e5bab49f8ed0c1"
    sha256 arm64_linux:   "2b394bb0da80a733c673889c281ae7f552ed854bf7658a980abd322ae58cdd57"
    sha256 x86_64_linux:  "5e8416167cc5705334a07ee176fc2dd5db90eb64aeb3d25304669d36a72779cb"
  end

  head do
    url "https://github.com/seehuhn/moon-buggy.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    args = ["--mandir=#{man}", "--infodir=#{info}"]
    if build.head?
      system "./autogen.sh"
    elsif OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      args << "--build=aarch64-unknown-linux-gnu"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match(/Moon-Buggy #{version}$/, shell_output("#{bin}/moon-buggy -V"))
  end
end
