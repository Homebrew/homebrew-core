class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://oath-toolkit.codeberg.page/"
  url "https://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-2.6.15.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.15.tar.gz"
  sha256 "8ad24aa9ff13c0edf3efc2573d90e85cf8b5ce7e82c08042574c1591f9d91eaa"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4d70c86c3ae6ddb9bf3978b01249f7b94e1dd5ce7dd6d3a94e3d3aeac70c8c7d"
    sha256 cellar: :any, arm64_tahoe:       "e4916bccb14b795fd7caf92402a2543726823de43d0cb3e3cb8c043692f1d025"
    sha256 cellar: :any, arm64_sequoia:     "4fcf347f4312bcdcd4eb3e30f06f54616cdde25d6eee67e3ec104b3bf9f5308c"
    sha256               arm64_linux:       "4843e3f37d4bf9566b9cdf1dfb9581d09561f811df140af9a95de871392fdbdc"
    sha256               x86_64_linux:      "ccbfe9159ffa1301b9fb130982bd94e1b31ab4e9dc736cd2eb17d5a03803a3c7"
  end

  head do
    url "https://codeberg.org/oath-toolkit/oath-toolkit.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libxml2"
  depends_on "libxmlsec1"

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
