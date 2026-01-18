class Gpcslots2 < Formula
  desc "Casino text-console game"
  homepage "https://sourceforge.net/projects/gpcslots2/"
  url "https://downloads.sourceforge.net/project/gpcslots2/gpcslots2_0-4-5b"
  version "0.4.5b"
  sha256 "4daf5b6e5a23fe6cd121fe1250f10ad9f3b936bd536d475ec585f57998736f55"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gpcslots2[._-]v?(\d+(?:[._-]\d+)+[a-z]?)}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "929c7fc634b2f18293d05562d73850df33ac33ff14e1d43bb62ccb42a4ab778b"
  end

  def install
    bin.install "gpcslots2_0-4-5b" => "gpcslots2"
  end

  test do
    system bin/"gpcslots2", "-h"
  end
end
