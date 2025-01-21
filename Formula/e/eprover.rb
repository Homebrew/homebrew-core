class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_3.1/E.tgz"
  sha256 "f84db3ec902488d5e166b5915c56e12397fd3660744387a2c5a6f81a5005a986"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "65ad63b92572ae8df5e194af0220e5c53bbcfe0f2b2bbad3c56a8986957c005a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6174d343789b0dc0c306310375663846d88dcdc00fc537640cbff2a132b26fdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f511d4a64d7ba346c3606a6a73401fcebecaaf77982f2087864eab271b10b9d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28b0ddd1441db834182b376f3ec50b9874c3161c2899a94a8e448b730ab6dad1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7dc29a61463dad9697692df024feb7a0637cfa185389a8e1ac450d338ec82e0"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd2a423d127773dc95f66ff87ab40d44b69b8f7bf6973ae9b0e484347cd788d"
    sha256 cellar: :any_skip_relocation, monterey:       "9953da977fd0841e944d76ab7b9b84c9e75c028d446a94d8f63e96f938aa26ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b87312e68d9ba0a2ea25d407ee3449bfbbf3cf9fad12dd690a4243d90427a83"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"eprover", "--help"
  end
end
