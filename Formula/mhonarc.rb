class Mhonarc < Formula
  desc "Mail-to-HTML converter"
  homepage "https://www.mhonarc.org/"
  url "https://www.mhonarc.org/release/MHonArc/tar/MHonArc-2.6.19.tar.bz2"
  sha256 "08912eae8323997b940b94817c83149d2ee3ed11d44f29b3ef4ed2a39de7f480"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ea3e05965fe74d294f44cc7c445c70bad845ce11cc27cb97a2aec3ca3f0d944e" => :big_sur
    sha256 "7100a27e7d9ea90abbee2f1d5eba2ef8a26c8fb38febb8fbf49f6da3a8bd785f" => :arm64_big_sur
    sha256 "d8d93f40967293512be76d832dd5ced8f4b40b720e20350f32a4237de04bcd19" => :catalina
    sha256 "23a6289c76372033b3c328a8fc67cc94b3b0895b7be58a67bb2f5da21c2b4707" => :mojave
  end

  depends_on "perl"

  # Apply a bugfix for syntax. https://savannah.nongnu.org/bugs/?49997
  patch do
    url "https://file.savannah.gnu.org/file/monharc.patch?file_id=39391"
    sha256 "723ef1779474c6728fbc88b1f6e9a4ca2c22d76a8adc4d3bd8838793852e60c4"
  end

  def install
    # Handle the hardcoded binary script
    inreplace "mhonarc", "#!/usr/bin/perl", "#!/usr/bin/env perl"

    system "perl", "install.me",
           "-batch",
           "-perl", Formula["perl"].opt_bin/"perl",
           "-prefix", prefix

    bin.install "mhonarc"
  end

  test do
    system "#{bin}/mhonarc", "-v"
  end
end
