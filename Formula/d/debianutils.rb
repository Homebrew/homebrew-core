class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.14.tar.xz"
  sha256 "531a9542b4054bfb4c26a9fd5f1e6489fc728f52785270ddd9434c14a56b1108"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3782397c00deb0f8d3d13198bd681161cb8e112e7a9365f060f718dc26c20853"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d830cf9f082dc6752b462d183a2518753b984ef3fb49f9076160bcbfea10cfbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9563157f8e82824f872dcf0640836e79981893ace4337ce5f2848269ea39d6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "747cc5a5d2afa31c806f9b730d93736161ae7fc952405da41de6cfecfd3ff555"
    sha256 cellar: :any_skip_relocation, ventura:        "60499bad528007624b39a56421bb53ad80366e60a4d85d5590d09acf07250506"
    sha256 cellar: :any_skip_relocation, monterey:       "125a8d0b0d17f9abc75b7e966d49ba72437988b862681484cf0ff7afb5fe4b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a593aa5c886b4c496b0fe543cefca2bf08a485537a78a44e41b8a1bb520e2735"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build # for libintl
  depends_on "libtool" => :build
  depends_on "po4a" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
