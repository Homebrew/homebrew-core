class Nethack4 < Formula
  desc "Patched, fork version of Nethack"
  homepage "http://nethack4.org/"
  url "http://nethack4.org/media/releases/nethack4-4.3-beta2.tar.gz"
  version "4.3.0-beta2"
  sha256 "b143a86b5e1baf55c663ae09c2663b169d265e95ac43154982296a1887d05f15"
  head "http://nethack4.org/media/nethack4.git"

  bottle do
    sha256 "69c0856eac6d8e9b61f3caa0ac1cef42cf6b2d16eaee75eca9734b0f4418a544" => :high_sierra
    sha256 "e839c203fb39fe659b358ca339563f7c8f00095a9830262cd2295e851d242841" => :sierra
    sha256 "42a56f8970103a2be4214437596155fc4f103c7b93fb47580f2eb00b9b4c6e31" => :el_capitan
    sha256 "2dcacbd514524bcac4c52df5c334f5b23e065f01371f6777b001ce8a1826df17" => :yosemite
  end

  # Assumes C11 _Noreturn is available for clang:
  # https://roguelikes.live/nh4-bugzilla/show_bug.cgi?id=568
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
