class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.1.tar.xz"
  sha256 "59e676aa53ccb44b6c39f0ffe01a8fa274891c91bef1474752fad92461def24f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d962cadd3808ac3efbc1f7ddb3aa8df8b1f1e8af07c19b26b4ff748435ceb816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f308eaa55cfb4e8bd0f0e0cd81384b851ae03db9b3ceee06d2a1c4f6bde474b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e24798cd0b451ca4f049482e8de67be4d9fde0d632f18036a06fe146800864"
    sha256 cellar: :any_skip_relocation, sonoma:         "a178761cb75758af3b1b7ae4c3c96163e20e4c0e87a65d3d886b4aa0bbecfff0"
    sha256 cellar: :any_skip_relocation, ventura:        "025b40b38db8f58791ad3efa2b9bcbe1405c226ff1dcf2577e571e389aa58acf"
    sha256 cellar: :any_skip_relocation, monterey:       "a4c00b3de41a02b8199d3519a438497213eb344b166bb0f85538a5b99eebcbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e6e22a099575d3463765a3d056a4b9417ee85f03325d9a014658e0b6bae1c4"
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
