class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.21.0/fswatch-1.21.0.tar.gz"
  sha256 "881945bbe218d057c465e0cb0d8fe682df088918ee047295159616d700e67a2f"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5901c81a9795f024bbb282615baaffa04c312dcded6d9fcc1fc02f72891342f9"
    sha256 cellar: :any, arm64_sequoia: "374a5191f91221ff987e205c55e7b678205c4c0b0069faa96ff327e5e353b4ac"
    sha256 cellar: :any, arm64_sonoma:  "309e29a06b9179d77c46f7be31cd49742bc12786bc445729bbc8bf53cf8d02ef"
    sha256 cellar: :any, sonoma:        "8e776584886e6bf2667c090d3f410bc60d946efc59a8a4c1acf7eb55d7d9b3d1"
    sha256               arm64_linux:   "03207ad334b6e8b5df3c81f2dfca8dc8520155067007e2b7e3a87f12c5475b64"
    sha256               x86_64_linux:  "1a5b326fd855eb15b446831525762623b4c640c09f9ee3224bb65cc1b2a33d60"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
