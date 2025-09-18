class Mp3cat < Formula
  desc "Reads and writes mp3 files"
  homepage "https://tomclegg.ca/mp3cat"
  url "https://github.com/tomclegg/mp3cat/archive/refs/tags/0.5.tar.gz"
  sha256 "b1ec915c09c7e1c0ff48f54844db273505bc0157163bed7b2940792dca8ff951"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a2e0124370647ca7c0f28de6ca280a78d6fd3fd93005a8dc60f9dffdea1fa665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5320e93de9cf583fc6b074a45c450c4ebb0fc6b86dbf887c9d77196a34655271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5c88c18fd159e395849b60bea5da8355546c7e3de34a521c5d5e9eb5f6ddd83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fda37f67df97cd462cbcda6e81dddb94bb1aea9615b899225ca8ca0f4a6d49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c1d1c6470951c00be5c9bc094686503ef53fb1a8ac7231c2de57232f2177f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5b602f2c0aafa37b863446069097523612ae44f2a14c4e49f179445a4b0edd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3624f0834cc2e7d9e613cc16c4102d49c9f64466ea1113a429a9e9849a850cc2"
    sha256 cellar: :any_skip_relocation, ventura:        "d7de68fc20fca732b5cc6f5d7a62f961e88d97e59f938a6f0aff4a96ad6125da"
    sha256 cellar: :any_skip_relocation, monterey:       "1e593ffe33a8086bf084b92d472420a2a462a34b7332fba0b29a71d3acda1a67"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cb3c8420e4858acf5edd529ce7d68c79d03f3d463c45460d9209308daa292db"
    sha256 cellar: :any_skip_relocation, catalina:       "07766f0495aa6c8566d8594a64f5004d1ad56f7e522f90cc1dcaf58001e7d2ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2f43d17baaae1fdf3ad7d231ad245e93212ff4fca7af462567fcc6c5980735fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1644ebe7bba692667cae251c36c2d7c7d2d5aa49e53291a247831bf866ed2ba4"
  end

  def install
    system "make"
    bin.install %w[mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf]
  end

  test do
    pipe_output("#{bin}/mp3cat -v --noclean - -", test_fixtures("test.mp3").to_s)
  end
end
