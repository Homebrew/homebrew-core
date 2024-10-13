class Mhonarc < Formula
  desc "Mail-to-HTML converter"
  homepage "https://www.mhonarc.org/"
  url "https://www.mhonarc.org/release/MHonArc/tar/MHonArc-2.6.19.tar.bz2"
  sha256 "08912eae8323997b940b94817c83149d2ee3ed11d44f29b3ef4ed2a39de7f480"
  license "GPL-2.0-or-later"
  revision 5

  livecheck do
    url :homepage
    regex(/href=.*?MHonArc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d0ee54ecef8975c8f168d0013f1266a4441661180be9475d858f712e40f78c8b"
  end

  depends_on "perl"

  # Apply a bugfix for syntax. https://savannah.nongnu.org/bugs/?49997
  patch do
    url "https://file.savannah.gnu.org/file/monharc.patch?file_id=39391"
    sha256 "723ef1779474c6728fbc88b1f6e9a4ca2c22d76a8adc4d3bd8838793852e60c4"
  end

  def install
    # Using Perl's `installprefix` rather than `prefix` allows install.me to use
    # Homebrew Perl directory structure even if the prefixes are different paths.
    inreplace "install.me", "$Config{'prefix'}", "$Config{'installprefix'}"

    system "perl", "install.me",
           "-batch",
           "-perl", Formula["perl"].opt_bin/"perl",
           "-prefix", prefix

    bin.install "mhonarc"
  end

  test do
    system bin/"mhonarc", "-v"
  end
end
