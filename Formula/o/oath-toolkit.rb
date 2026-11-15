class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://oath-toolkit.codeberg.page/"
  url "https://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-2.6.15.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.15.tar.gz"
  sha256 "8ad24aa9ff13c0edf3efc2573d90e85cf8b5ce7e82c08042574c1591f9d91eaa"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  compatibility_version 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "105e3fd83b633bf6997782f273b543eca735f70486fe89372aa0bb3f41999d87"
    sha256 arm64_tahoe:       "2bbd6a571051d2636fe7d17d6d55ac1b69ba9e04375f39dae39909b14dd5a4db"
    sha256 arm64_sequoia:     "0615216e69455c0f2a2f6f8e2ced8e7c73da55ca2f636e43aa21c887f04ca1cc"
    sha256 arm64_linux:       "8b1f26d6d999b30fd2df65bb1b1a6cf431fc56d3cf6abb26536a9e062b327e6f"
    sha256 x86_64_linux:      "996eaa6198b5db2abeb586835784c2ffd98fc1964ce45a26278c35595fb83a41"
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

  deny_network_access!

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
