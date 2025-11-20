class Mkvdts2ac3 < Formula
  desc "Convert DTS audio to AC3 within a matroska file"
  homepage "https://github.com/JakeWharton/mkvdts2ac3"
  license "Apache-2.0"
  revision 3
  head "https://github.com/JakeWharton/mkvdts2ac3.git", branch: "master"

  stable do
    url "https://github.com/JakeWharton/mkvdts2ac3/archive/refs/tags/1.6.0.tar.gz"
    sha256 "f9f070c00648c1ea062ac772b160c61d1b222ad2b7d30574145bf230e9288982"

    # patch with upstream fix for newer mkvtoolnix compatibility
    # https://github.com/JakeWharton/mkvdts2ac3/commit/f5008860e7ec2cbd950a0628c979f06387bf76d0
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mkvdts2ac3/1.6.0.patch"
      sha256 "208393d170387092cb953b6cd32e8c0201ba73560e25ed4930e4e2af6f72e4d9"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a5a856ffc05eeb709725402da52d138058873ba0876d66b95106ac95e47489eb"
  end

  depends_on "ffmpeg"
  depends_on "mkvtoolnix"

  def install
    bin.install "mkvdts2ac3.sh" => "mkvdts2ac3"
  end

  test do
    system bin/"mkvdts2ac3", "--version"
  end
end
