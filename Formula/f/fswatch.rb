class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.19.0/fswatch-1.19.0.tar.gz"
  sha256 "c0f10b0961af73496247501f3a6cad61e3a71018b87ec14e580b3bf4c5d9427d"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "afb9915aac832d01ebada0eb640cabc8d10ff371f0692dde6318306486d6b5e7"
    sha256 cellar: :any, arm64_sequoia: "adff23a72f49510738f842a96d1a6872c8384a86bed36d3bfd363bbef30208b3"
    sha256 cellar: :any, arm64_sonoma:  "677fcc3a484e8500ab2bcb06afd245b367693c65aee550e4a30feb10bf420dea"
    sha256 cellar: :any, sonoma:        "39beb59ba5ec2a3c6fdf8cd595cfb1094759abd6492a9c7bfab2fc5a62b623cc"
    sha256               arm64_linux:   "d6fcfd34597d592e58d53fdfe1f3defc18bf4ce4aef5d0f82921aa23af7368e3"
    sha256               x86_64_linux:  "3aa07d847014715001b53e012c80053399839a2098befba04637ce814b846b62"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
