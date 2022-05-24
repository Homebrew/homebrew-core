class Cfv < Formula
  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://cfv.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz"
  sha256 "ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38eaeb7bfcf83dbf9ab48ad9a1a0d4a71a91ae830792397c5424e8cd743ad5de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09dd4b6432d6cac583e1ac82d2d65c10f2d3549f4d7a1017dbcce07ae6123238"
    sha256 cellar: :any_skip_relocation, monterey:       "a71d821fcf88da93b92fc6c8443a63e1bf14474e74bcff47026474146c8c58a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce1654aa4805deb6a80b9ec470306b879b79d5e25e151df1e4c78e498c0e214"
    sha256 cellar: :any_skip_relocation, catalina:       "cd4fac08aac6490ade28d8b370e006c720bab5df939caadb92b25af278a4384a"
    sha256 cellar: :any_skip_relocation, mojave:         "251348813c0a811e6ac298432967d19e42bfa73bbc3217eaa0b63bec4b78d98d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7452ead7901f4f4ab2683cd391af82f856eba1a57c11d07c038ca18507535dac"
    sha256 cellar: :any_skip_relocation, sierra:         "449f4b10a0371005f04bffa6271364824a83fbb68cb15208168c19457b987b6e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "49b83783b5737a364504fdd9fd09672134e0103c7bb8152741d67fca455fde04"
    sha256 cellar: :any_skip_relocation, yosemite:       "df85f8ee2901bb0b3033a3158d04848bb2fbc455f8af12d7d6eb6869c1471ed9"
  end

  def install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
