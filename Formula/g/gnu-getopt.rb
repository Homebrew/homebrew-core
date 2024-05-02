class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.tar.xz"
  sha256 "d57a626081f9ead02fa44c63a6af162ec19c58f53e993f206ab7c3a6641c2cd7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3608233d24d10ebd675f6abd65c0d8af7ceb39893735d4fd764651761dcceb38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46071b3f54a2b0f7c65ef6ac547a037485391e2a702811ab8df21afc006a386b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae9fad764fa340615ee120ea09325b3b1960caf67189e136b5380440d1acef7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2b1a5d1f12bf2d60ed4103e1c4f86c04db6b5339cd307cf820e6cdd6998e2d0"
    sha256 cellar: :any_skip_relocation, ventura:        "7756fe89d001ef0dcefdf1d559a6760bfadd85cb69531b4953f1a8c31d93307f"
    sha256 cellar: :any_skip_relocation, monterey:       "f9c9d0b227b2e29913c496d4cc33f00b0f6e63f18951f96ac6462f6063fd12d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f79fecd9dc7ae7ab64f5e9d55e34fb99556bcad9a07185c3d0da94ec1709e3"
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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-liblastlog2"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
    doc.install "misc-utils/getopt-example.bash", "misc-utils/getopt-example.tcsh"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
    # Check that getopt is enhanced
    quiet_system "#{bin}/getopt", "-T"
    assert_equal 4, $CHILD_STATUS.exitstatus
  end
end
