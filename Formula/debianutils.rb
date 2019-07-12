class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_4.8.6.2.tar.xz"
  sha256 "aca388ba52d19f7c2f7991183a1c15c4d375c692a6cb4bae62cd17b485b10bba"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f91998b3e0568cb8623d13539a52dd63f0f525cabbd7a54c1647344d0fed5ca" => :mojave
    sha256 "6c595d2a911ce71142e20ee3c114b712f819e62e869fbd1a228c6704f4252b2d" => :high_sierra
    sha256 "6ba3ee8c75dc9727df4b2500cf286c3c75e17eefffcb1ef03ae11699bb9edfed" => :sierra
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
