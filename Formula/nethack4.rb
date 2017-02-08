class Nethack4 < Formula
  desc "Patched, fork version of Nethack"
  homepage "http://nethack4.org"
  url "http://nethack4.org/media/releases/nethack4-4.3-beta2.tar.gz"
  version "4.3.0-beta2"
  sha256 "b143a86b5e1baf55c663ae09c2663b169d265e95ac43154982296a1887d05f15"
  head "http://nethack4.org/media/nethack4.git"

  # Assumes C11 _Noreturn is available for clang:
  # http://trac.nethack4.org/ticket/568
  fails_with :clang do
    build 425
  end

  def install
    # 'find_default_dynamic_libraries' failed on 10.11 and 10.12:
    # https://github.com/Homebrew/homebrew-games/issues/642
    ENV.delete("SDKROOT")

    ENV.refurbish_args

    mkdir "build"
    cd "build" do
      system "../aimake", "--with=jansson", "--without=gui",
        "-i", prefix, "--directory-layout=prefix",
        "--override-directory", "staterootdir=#{var}"
    end
  end

  test do
    system "#{bin}/nethack4", "--version"
  end
end
