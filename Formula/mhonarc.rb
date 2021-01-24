class Mhonarc < Formula
  desc "Mail-to-HTML converter"
  homepage "https://www.mhonarc.org/"
  url "https://www.mhonarc.org/release/MHonArc/tar/MHonArc-2.6.19.tar.bz2"
  sha256 "08912eae8323997b940b94817c83149d2ee3ed11d44f29b3ef4ed2a39de7f480"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c3adebd39e28c108be5623500a4ba851d62437df8b82b8211b7ab872633a5ec0" => :big_sur
    sha256 "398d2e90404d82e85bee66a2a6738f8e111c47d59aea0a3cfc6f425479438ffc" => :arm64_big_sur
    sha256 "12e9e0b46aa96c824594af7e8d68faeb11940f9dd42574524e906ab9bb8d2082" => :catalina
    sha256 "63205520df1e3503e6faced33cce8cbfdb0198409638d353b3bbe15a5bf18928" => :mojave
    sha256 "58ed9777ef00e00f33a7a7cc71c8eea8841d987a933f2bf8e9beffc37d5f7f2d" => :high_sierra
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
