class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"
  head "https://git.savannah.gnu.org/git/enscript.git"

  bottle do
    rebuild 1
    sha256 "5e66a847d27142da7b24603988a3f31cc841fdab66c9cb658a8a0f5f4da9a82c" => :mojave
    sha256 "4b9fefd4bafc5f190272b8ed5bc4c0fbdaf4e1cdfa03aee7b7ef2f829500bc0b" => :high_sierra
    sha256 "dea5f069c92bd1b5d2e3c1f0440d8ed5281d9ee44225e28295a1f682ff43a934" => :sierra
    sha256 "e55d3f93f7a4eb89d8007d9c0c49d6b7f52778191f2601da648afff0098a6663" => :el_capitan
    sha256 "d1c1bfc90a9e140a3d257d976729fc9b6e55118a10364ce1e3dc3dd26388edc9" => :yosemite
    sha256 "f2be9be9caeff58dbec3c9abf3ff5554865e6a3ee4db91d156edce8ddf5e666e" => :mavericks
  end

  depends_on "gettext"

  conflicts_with "cspice", :because => "both install `states` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /GNU Enscript #{Regexp.escape(version)}/,
                 shell_output("#{bin}/enscript -V")
  end
end
