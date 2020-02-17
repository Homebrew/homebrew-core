class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-2.35.1.tar.xz"
  sha256 "d9de3edd287366cd908e77677514b9387b22bc7b88f45b83e1922c3597f1d7f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf96a141957a6e1e5cc3c2576f8d8855f01be43a7332299bc5a65ca80a44481f" => :catalina
    sha256 "615da7a589946f2ae6fa43bd24f9811c1772fcbd2370e976425effdbc29dd32a" => :mojave
    sha256 "91e11554e74963e38d11fc7483d1ec18ff47eb24154b4119869e451114730539" => :high_sierra
  end

  keg_only :provided_by_macos

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
