class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.4.tar.xz"
  sha256 "634e6916ad913366c3536b6468e7844769549b99a7b2bf80314de78ab5655b83"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921d27f26477fdaab5bb26e05c18e6632d6f70148fd3146b369e809315f47ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab03d3ec493c05c601a045e75b2630063ce6a9c0fc4d0ef08b03740461e603d3"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa16133ac2bf8620f45b731e245309d797291ba006f0c8b27b49c1057c3c59a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b13a5cf0ca461780e2f5a7866b00abea8884e663404489c870570451b5b248"
    sha256 cellar: :any_skip_relocation, catalina:       "91a066c638475bde088d05d5d9d47021f8700671bc4672430dbcbffb2e508400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae03962a4d30074e89c5b44aa4b60a44974cfb70f76e37e9677ae159931ca397"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build

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
