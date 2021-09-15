class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.42.0.tar.xz"
  sha256 "d8f152314d7e4d3d643610d742845e0a016ce97c234ad4b1151574e1b09651ee"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 big_sur:      "4f9a5013aeefa5d20c9f1776c70685ab79572cc507f752672d0abc49b2b19ad7"
    sha256 catalina:     "c63e29ce190fb0beb5edbd3f0360eb7ce3694ee3144269608bdf2d56faef2b60"
    sha256 mojave:       "e972813fe9f1942b55c981ce75b21da479588912583ed52ed23da7c69f1f5d60"
    sha256 high_sierra:  "c0004802fb0a257197e96c4b7005a2ca63ca1d881c3b335d255b85f9e96d0124"
    sha256 x86_64_linux: "89adc4bf4ba892e03f2c55c0b892ee9da2116f43681f27b96a0398b531beac1e"
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
