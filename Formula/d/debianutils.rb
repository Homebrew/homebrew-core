class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.11.tar.xz"
  sha256 "dc0340ab025d2daf7ac059229448a06cc5bf0570fc2b581d7f4984e8ae971abe"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c7cfaeceddd2518e16795c21b8ae574b83e687b6087ffb7d81d843804dd0de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe752d1e901a5dff5a2e1829b2d8706f5be413c973f051bcad8af861a4e6a6bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "638b8cf91809373a712ee814beb054137854aec695ec580c6d330d0be1fb10d7"
    sha256 cellar: :any_skip_relocation, ventura:        "1083f0471a7fb8521c12eb41b3151897c44e6f679b703f3c7ef91adc98d61076"
    sha256 cellar: :any_skip_relocation, monterey:       "ce230ab5d5ed26a0f7fc518cbd0352f42d8bd9cb45ea2c99cd87f9df206681f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f48634a7016caefd6ad57af42e5167d2dcbd0280c613508d434835b711f62542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6034d8a4abedc792205416110c3c52831046099b95961246516a5ea42e0bd94a"
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
