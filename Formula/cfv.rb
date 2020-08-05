class Cfv < Formula
  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://cfv.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz"
  sha256 "ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd4fac08aac6490ade28d8b370e006c720bab5df939caadb92b25af278a4384a" => :catalina
    sha256 "251348813c0a811e6ac298432967d19e42bfa73bbc3217eaa0b63bec4b78d98d" => :mojave
    sha256 "7452ead7901f4f4ab2683cd391af82f856eba1a57c11d07c038ca18507535dac" => :high_sierra
    sha256 "449f4b10a0371005f04bffa6271364824a83fbb68cb15208168c19457b987b6e" => :sierra
    sha256 "49b83783b5737a364504fdd9fd09672134e0103c7bb8152741d67fca455fde04" => :el_capitan
    sha256 "df85f8ee2901bb0b3033a3158d04848bb2fbc455f8af12d7d6eb6869c1471ed9" => :yosemite
    sha256 "f251efc545293925f29093f8574495ebbbfe1cbad2a285a7a531e357310e3d1f" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match /9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38/, File.read("test.sha1")
    end
  end
end
