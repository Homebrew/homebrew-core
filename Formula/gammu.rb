class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.38.0.orig.tar.xz"
  sha256 "561cc1f116db604a7a2c29c05f2ef7f23a4e1fff1db187b69b277e5516181071"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "9c41883474413c0df0bf105a64493e4efb90d71622e52166e402787eb0ecf626" => :sierra
    sha256 "d95085fde0534cd74dffc996fbc069ff2aaa862a95853f013370d92101ab7bdb" => :el_capitan
    sha256 "cbc21d234f9ce0674b5b193ba4193747cb79633189a690f98bede4797a8849da" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
