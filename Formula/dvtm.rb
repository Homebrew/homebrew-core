class Dvtm < Formula
  desc "Dynamic Virtual Terminal Manager"
  homepage "http://www.brain-dump.org/projects/dvtm/"
  url "http://www.brain-dump.org/projects/dvtm/dvtm-0.15.tar.gz"
  sha256 "8f2015c05e2ad82f12ae4cf12b363d34f527a4bbc8c369667f239e4542e1e510"
  head "git://repo.or.cz/dvtm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "927868c56e99b513a5dcf873ac444a7f688d8e32435d5535ca98cff078a2f0d1" => :el_capitan
    sha256 "3707849011fc54151fa110c66578ea3ad33d9cb6047d59ee10dc0e3a217ee0b4" => :yosemite
    sha256 "88bffcbc907f9ffa900331acf5f994af07f5c1787c328ac56c72935813f57b92" => :mavericks
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "LIBS=-lc -lutil -lncurses", "install"
  end

  test do
    result = shell_output("#{bin}/dvtm -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^dvtm-#{version}/, result
  end
end
