class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.2.tar.xz"
  sha256 "f7516ba9d8689343594356f0e5e1a5f0da34adfbc89023437735872bb5024c5f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae1263956351e0cc6482a31d4950008804c2a1bd72567d06759fcf81884271c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca1fed65658b4bc72775636b6cb21e30dd0ff3e0521b80eda2ed37119f89838d"
    sha256 cellar: :any_skip_relocation, catalina:      "e923cad6e80e57326467d08fecdda7150bb3a6a05c8d1d1b33dac1ef54b19e70"
    sha256 cellar: :any_skip_relocation, mojave:        "9418bd6b173a0af13f89d10487129b7bfcd5690eb58fb3a1e253f5eadf03acdc"
  end

  keg_only :provided_by_macos

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
