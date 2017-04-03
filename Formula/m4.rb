class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftpmirror.gnu.org/m4/m4-1.4.18.tar.xz"
  mirror "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
  sha256 "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b72de8c334cf6faa6f29a420bb87d9ff4d25b4ded8c83a47c27f60840ea96d6" => :sierra
    sha256 "a740efe575f7b6a0b64bf42afdd9d2d64b67f7551fde00c628e1d6317a084166" => :el_capitan
    sha256 "a3d45ad75fabb47348fa84fe3ddf2c0aae917e43a65db4959b803ca298faccd3" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output("#{bin}/m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
