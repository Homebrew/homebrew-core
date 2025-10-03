class Jcal < Formula
  desc "UNIX-cal-like tool to display Jalali calendar"
  homepage "https://savannah.nongnu.org/projects/jcal/"
  url "https://download.savannah.gnu.org/releases/jcal/jcal-0.4.1.tar.gz"
  sha256 "e8983ecad029b1007edc98458ad13cd9aa263d4d1cf44a97e0a69ff778900caa"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/jcal/"
    regex(/href=.*?jcal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "aba60dbce990bacb3f58d4a08e1a5251e74d2d3f57965eb206f2bc15a7bd2390"
    sha256 cellar: :any,                 arm64_sequoia:  "31377fb6a087e5e70e9ae8a1bc7ac390db8efa860f7a956a759b27e710fe21e2"
    sha256 cellar: :any,                 arm64_sonoma:   "45f6803d072d0989897f3f1995abd33b4f1036b8b7921fb9abfa59ee9467df90"
    sha256 cellar: :any,                 arm64_ventura:  "199711a3aa65d8d6b5d7ae804e99f0025ad8eb59c77f37d4058566edc6c0d1eb"
    sha256 cellar: :any,                 arm64_monterey: "6f1986d499d27fd07525390066318239e9efdac990a58578ef3fe2147d32563b"
    sha256 cellar: :any,                 arm64_big_sur:  "6995c49236be96cf2adcf11cd03a88f46436ca66061de24d087c1c69aa4b9f6c"
    sha256 cellar: :any,                 sonoma:         "ec81894b74a70c48921e691f448f6d30e12d04cbfd84d1463d6419464f1cedfc"
    sha256 cellar: :any,                 ventura:        "feac90459a79da88e1fc37a090d811e5c76a43cae3f1fc6075c2da8e6a3e3fcb"
    sha256 cellar: :any,                 monterey:       "2ebbf3f00eaedd9e2a539af5eab274bc5a1417cf3e7d44d889272bef86c83a79"
    sha256 cellar: :any,                 big_sur:        "00a9eec192b14b6b4a442e1268bd7727df19923901d36ca225a32e69477df5de"
    sha256 cellar: :any,                 catalina:       "0544ee162b480d5999a312cf721b40007901f964b20edbdd8e062b2e95c64157"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e7566343f085ff5aa380a9a52b6ef5299c1b09f6dfc629fdcd9fe1937fb424f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b67ec668f4880126342f70bb106b66744773ebbe8afc9e11eacf96d5a11108"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    shell_name = OS.mac? ? "/bin/sh" : "/bin/bash"
    system shell_name, "autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"jcal", "-y"
    system bin/"jdate"
  end
end
