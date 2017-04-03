class Bc < Formula
  desc "arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftpmirror.gnu.org/bc/bc-1.07.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bc/bc-1.07.tar.gz"
  sha256 "55cf1fc33a728d7c3d386cc7b0cb556eb5bacf8e0cb5a3fcca7f109fc61205ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "b758b4f34df61c0403582cc3ba65e260c17278fd2b0a9b668ffc09a88902f8a4" => :sierra
    sha256 "5fd6235fed77227fc847538d53955420ed5cfb5d8e562ed2f24e7457696757a5" => :el_capitan
    sha256 "30e0bf45f79e742a73c0b1ec4aca944d33b5a46c94e8895a4ad3cb600f7a2735" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bc", "--version"
    assert_match "2", pipe_output("#{bin}/bc", "1+1\n")
  end
end
