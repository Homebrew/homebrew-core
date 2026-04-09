class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "https://github.com/jonmacs/jove/archive/refs/tags/4.17.5.5.tar.gz"
  sha256 "4261d7cab02816eb03f3f356a0a2869d7f6168fce53478ede8e5fdd06a9ecfb9"
  license "jove"

  bottle do
    sha256 arm64_tahoe:   "ee1248e197df0c81afc0548004d8ae314d911b63470761a839421d4b3a4b4ba5"
    sha256 arm64_sequoia: "718cb56f6abe1b157dc232e68f311473651619b07d09491ef7515f4879ef79fe"
    sha256 arm64_sonoma:  "2727f000de388acb8e1d2c1681af7d994e2b3f11b8d9820b485dddf061ec6853"
    sha256 arm64_ventura: "6e9cfd50901196b64ab92526a1be8591bfe9d1155b4bac1e40e9c4919b613119"
    sha256 sonoma:        "e72bb81fde21a1e8681fcfbf6255894438e4169d7b2e7947f83be7ec99a28929"
    sha256 ventura:       "1a7d7b4b004063ba6099ed680695c1b18ac9f73d3ef83e2b45d703186df468af"
    sha256 arm64_linux:   "0682f731ffeeaf52b72dc4e5c43f8e22c098ad845d5021f59ed7f4c589d989a7"
    sha256 x86_64_linux:  "ae68e348cd028def90d76ae9065520fc1f9812874aa0d61fad3274acc09529fc"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "DMANDIR=#{man1}"
  end

  test do
    assert_match "There's nothing to recover.", shell_output("#{lib}/jove/recover")
  end
end
