class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20240307.tgz"
  sha256 "339d311c6abb240213426b99ad63565cbcb3e8641ef1989c033e945b754d34ef"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20e2ca3e1b93bc25596f78931719a614a19a9306d242ea031d2e7be0232c814c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "077e8db227e0a15eb1af3939b1b7f2965525061973e6f04f62e63c4b0b297739"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f01de51cb09386d9c95035b79bfcb6cb36bac30e579c9299d3efea265c1f88"
    sha256 cellar: :any_skip_relocation, sonoma:         "f799b5983c645a660c5e8bea34991519322a07d7d9e7e851b236bfcf714b7e6f"
    sha256 cellar: :any_skip_relocation, ventura:        "1d4c7010179f9b989a421d6cadeb8bf813c04e8afd38df658a9880ee46f6a6c2"
    sha256 cellar: :any_skip_relocation, monterey:       "8af54079fdf9305ece3495c43b16ad77dbe9646bf224fb189f8857bf32edc986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd1a1b17bcb5752dcd75c5d0762cc07890946f5335eecedf2c9c3645946fc3f"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
