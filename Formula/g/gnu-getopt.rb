class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.2.tar.xz"
  sha256 "d78b37a66f5922d70edf3bdfb01a6b33d34ed3c3cafd6628203b2a2b67c8e8b3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8025c5fff22016f9d616a7f7f94de79ece01db73f6e2ef3032a038621e894abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab9985a8189d89d997042764ca3a413380798f7faddb032c77613c392724daae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15c97983241a60691b09b15684351304f1d00933c46a103ef9521b985a34e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63ab4b156e1fcc16b6e014f5a92fac3087c7c371004c134d12276e3f4f469d46"
    sha256 cellar: :any_skip_relocation, sonoma:         "116ef535edda1d42f67f7eb1411cddeea237e835ae69c2171d9fa6b2df843f37"
    sha256 cellar: :any_skip_relocation, ventura:        "97cedb6c84bf6bb1d3a9335800992efe37b5aebd56daf0f99f3b752bff1a3c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "c70effa81195e0495de1ae6538c0efcf35397aedeb756ef7294376e3bbe2f0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0accfa7f1ff3844f5976a87e794812ffc3598251542dbb370cf0f4e43623f37"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD getopt"

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-liblastlog2",
                          *std_configure_args

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
    doc.install "misc-utils/getopt-example.bash", "misc-utils/getopt-example.tcsh"
  end

  test do
    system bin/"getopt", "-o", "--test"
    # Check that getopt is enhanced
    quiet_system bin/"getopt", "-T"
    assert_equal 4, $CHILD_STATUS.exitstatus
  end
end
