class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "https://code.google.com/archive/p/aoeui/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/aoeui/aoeui-1.6.tgz"
  sha256 "0655c3ca945b75b1204c5f25722ac0a07e89dd44bbf33aca068e918e9ef2a825"

  bottle do
    cellar :any_skip_relocation
    sha256 "79a6d037053bc2b3fcd21870ccc274ad02f8e47bde5c9755b8665c25609ddd3a" => :catalina
    sha256 "c1e5c83add4ecaae6e45f5bed048045a0b2e81794244daf93028161bdd71e031" => :mojave
    sha256 "946acae5b1b88cb67bf805e6b8a8d591e3267d799c9d1a924e60217218166e78" => :high_sierra
    sha256 "1b04b93c490895121fed315f685d60cb96551b971ca1433a5240425cfa31dfcd" => :sierra
    sha256 "62a04ac0fd27e76f4f77da95e7d5aaf75488765f98b02574ae7dff0508cd9f13" => :el_capitan
    sha256 "19f622466c20ad4ddff2fc97ac186e189d5a8bb02dd405ed2a93c5d13a88b1f4" => :yosemite
    sha256 "a3ac3238356624a12b20df52c98d2bc52e0d785745e393928fc4c629212d1406" => :mavericks
  end

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
