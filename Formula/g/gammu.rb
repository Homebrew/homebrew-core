class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://github.com/gammu/gammu/releases/download/1.45.2/Gammu-1.45.2.tar.gz"
  sha256 "92478c1c6d8df193f3d5e36648fd05fc3eff26254034f025cad2a0ffba5aec23"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "394a8dad1c655a3a025560db9693561889bcfff9537997fe43a3e30040eb4d7a"
    sha256 arm64_tahoe:       "490f0fe54de8609559b84810b73bf98144043d0091836c341581539b9ffd6292"
    sha256 arm64_sequoia:     "fca07192c895b768276f6bb63ee6abd0906225fa9e49398423effce6f851c6c5"
    sha256 arm64_linux:       "ee21913609a57603e77de17d2e86b8276647bd4d527f35cc544ddbfdcfbf8619"
    sha256 x86_64_linux:      "d2a925217e0b2a6bd9ed9cd4bf7cdb3041ac83be4e168c599e379ae7ce1cdda3"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_Postgres=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end
