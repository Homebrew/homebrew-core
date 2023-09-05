class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.2.tar.xz"
  sha256 "87abdfaa8e490f8be6dde976f7c80b9b5ff9f301e1b67e3899e1f05a59a1531f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f49b9db06a09a471e7a8d74c1e8d38d71eb18ff1e915afdafe4947b082217f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e862142e34c7703182b4330d8d857fef08dbea9546bcd9f651496e2b14e6f66e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a4ff0005a74a517696be56bdca364a1fa1d636b7c5cb428023798e266bb8370"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b6238e59f8cc2be57417b9952dde571b3df1a28bd4f9a42d453c124a3e303f"
    sha256 cellar: :any_skip_relocation, monterey:       "da735fe28a12cf5f6dc2cbc62b4b4bddd80d4b9017f7fbf5f5ef68976a3c4d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf3c02753157cad824055614a0d834bbc0eeb638ea1faef32b916a1b564657d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a81188804feb6a3040c14e813e591f3e86214233a51ba4d9a5d77823a18712a"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
