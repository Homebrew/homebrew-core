class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-2.35.2.tar.xz"
  sha256 "21b7431e82f6bcd9441a01beeec3d57ed33ee948f8a5b41da577073c372eb58a"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4eda655b18149121dd39d19928b64b63f7310469ad1d64a232996b61afb5016c" => :catalina
    sha256 "ff402c05420ff975374689ce0f185c8d9f9578f3e9113e935cf3030f0743c31c" => :mojave
    sha256 "a9c00a4e5483a0636b9a8dc6def5cc73c53f7b6ef16a476af5d470d4d6e1e5c4" => :high_sierra
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
