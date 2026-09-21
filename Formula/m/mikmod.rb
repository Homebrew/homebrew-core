class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.10/mikmod-3.2.10.tar.gz"
  sha256 "465e99d89d762608b7d0c0a103a58eec68c8c28ae6bbd196354c13433e40d20a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/mikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "afb351852f98b9a57e0b5c56abba7818be7ebdbe6ad3ed484dfb12311757a17d"
    sha256 arm64_tahoe:       "df149f89ada0bd17a538f133d9d67ac90dd70c747b0b9af21d9e00512bbc6ffb"
    sha256 arm64_sequoia:     "2d94a2007d6292b56c23ff35152f1c83619184d514eaca702ad3dcbf070e2f3c"
    sha256 arm64_linux:       "54f2881b03cab568f39f708c48f55bd769c5bf5a8eaa4f7f73254279e2184fad"
    sha256 x86_64_linux:      "35cfb09c5da37a42c233c97bc97e452b4d19a02a7e34c1b27be5d446dde5958f"
  end

  depends_on "libmikmod"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
