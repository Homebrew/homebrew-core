class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.11.2.tar.xz"
  sha256 "3b680e81709b740387335fac8f8806d71611dcf60874e1a792e862e48a1650de"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d5bf51c189a6156ba22a03e328cf8f686e9e7612f6987dc91d5348934a16357"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391f28aad571638e900584cb160e65029ff58f29af2e1cc078cc64fe742e042c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d85a9b994fc1a8feee952fcdc7f745801fb1e39fdc733ea76f69c22dd7636fef"
    sha256 cellar: :any_skip_relocation, ventura:        "79dd10f7b58279ab6a02cbe9ea319c7d992b5a3dda5bcabbe6ac592d4b331a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "936c65c8eb8cd3f673792bedbfea37dab226367718f4d33b4213cf62da1f1c6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c099d05496a2f897a037aa8b20944faa62254b5486838a29f9735c696e7cb73"
    sha256 cellar: :any_skip_relocation, catalina:       "b6a3110aa8113eb30d7b3dd71ac194d476969322e2a184172c8da9923c497c19"
    sha256 cellar: :any_skip_relocation, mojave:         "5d50261564a4696a8f9d0eed99ffa0ed8eebc8344a0365d5c9b4083a54d3b6de"
    sha256 cellar: :any_skip_relocation, high_sierra:    "be68111406f254d184ffecf06a181df3000525e05b18f9b072c4cdd0ef30b3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd96fb4733f4fc575514e778d83ee69006440d867df416ed58b45bfb954ae30"
  end

  def install
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
