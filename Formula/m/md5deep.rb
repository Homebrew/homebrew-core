class Md5deep < Formula
  desc "Recursively compute digests on files/directories"
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/refs/tags/release-4.4.tar.gz"
  sha256 "dbda8ab42a9c788d4566adcae980d022d8c3d52ee732f1cbfa126c551c8fcc46"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/jessek/hashdeep.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c59d131c78aa6ee76fdfe35f4dd4488f5edfbdad5eb48eaa549396168adc31c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6d92356eb626035ee2f2e8b412b0a5ca36fa31a8d6d16fe583f9dfcd6ed57a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e4229518a382d9eb9d0b5fe87118a0f4a532c33b535791db257432502ac9e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34dc60be87a6f4d9306468492222ea35455aa08359603f2e1bffa3ae221405de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b64f262b089ff96008078a6dc0f84cce93deec0740b3476279931d982bc9636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d910e7454fa350663a1955628c254b7acf813dd7b3aaec162a7be2c002197f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7741049d40f5fc9989fa69e8a55dd1c1f75c75155a89a0a0f90575afdcf9b2c3"
    sha256 cellar: :any_skip_relocation, ventura:        "46f9ea31605459d954b815bc85db4d2c5b5a7c96e81aaeac63ab0eaa2954faeb"
    sha256 cellar: :any_skip_relocation, monterey:       "58e0dfb42b8a8b0d89745dc0446ee660754f3350c776702384edceb1fe14b8b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d53f71333428c98de807b2ed6be18fcfd62d473d9994e19db7c7a8db390cac95"
    sha256 cellar: :any_skip_relocation, catalina:       "3156ba425284d497cdc5377c1d5d7659fe741811c5b1a390a2dd45f98bf0a19a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "786f0046cd92fd6e6689b0c6dd0cf202ad019a28d9ecfd3f29c356c78639bf91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a36e25199a0c133790f452fa716c07fc6bc724714f66c30be47f5989b703ed46"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix compilation error due to very old GNU config scripts in source repo
  # reported upstream at https://github.com/jessek/hashdeep/issues/400
  patch :DATA

  # Fix compilation error due to pointer comparison
  patch do
    url "https://github.com/jessek/hashdeep/commit/8776134.patch?full_index=1"
    sha256 "3d4e3114aee5505d1336158b76652587fd6f76e1d3af784912277a1f93518c64"
  end

  # Fix literal and identifier spacing as dictated by C++11
  # upstream pr ref, https://github.com/jessek/hashdeep/pull/385
  patch do
    url "https://github.com/jessek/hashdeep/commit/18a6b5d57f7a648d2b7dcc6e50ff00a1e4b05fcc.patch?full_index=1"
    sha256 "a48a214b06372042e4e9fc06caae9d0e31da378892d28c4a30b4800cedf85e86"
  end

  def install
    system "sh", "bootstrap.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Do not reduce the spacing of the below text.
    assert_equal "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt",
                 shell_output("#{bin}/sha1deep -b testfile.txt").strip
  end
end

__END__
--- a/config.guess
+++ b/config.guess
@@ -797,6 +797,9 @@
     arm*:Linux:*:*)
	echo ${UNAME_MACHINE}-unknown-linux-gnu
	exit 0 ;;
+    aarch64:Linux:*:*)
+	echo ${UNAME_MACHINE}-unknown-linux-gnu
+	exit 0 ;;
     ia64:Linux:*:*)
	echo ${UNAME_MACHINE}-unknown-linux-gnu
	exit 0 ;;
@@ -1130,6 +1133,9 @@
     *:Rhapsody:*:*)
	echo ${UNAME_MACHINE}-apple-rhapsody${UNAME_RELEASE}
	exit 0 ;;
+    arm64:Darwin:*:*)
+	echo arm-apple-darwin"$UNAME_RELEASE"
+	exit ;;
     *:Darwin:*:*)
	case `uname -p` in
	    *86) UNAME_PROCESSOR=i686 ;;
