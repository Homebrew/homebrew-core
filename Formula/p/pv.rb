class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.1.tar.gz"
  sha256 "20d38794b00fa9384a1ddf9e395a8357a0782cd95c8b74cf1df8df6388950eec"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "72362e269cfdfbc99872cf61f1f4c723e99591ccd3dbe3ec2347e54d317f7c06"
    sha256 arm64_sequoia: "1bedeb004a4a8a9f96fde68c054eaaf1336146f049f84eb8e511456cfa3fbf23"
    sha256 arm64_sonoma:  "6cf9fcfe8c564060ce2f5e851411c4667592423afcdc8df75c3b830389174948"
    sha256 sonoma:        "2b3f83d76d324c045200d9cd8faa70e6dfd2bc74abfeb70769ef88775ceec9c6"
    sha256 arm64_linux:   "1fef27f104c577f3dca0f9af12f8b33d1e169695fce04f1ff5a85efb8093c562"
    sha256 x86_64_linux:  "98577ae0ce91ac9bf127921936842ca1c1dfbbe48ced51764b76c0cb1a6b040d"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
