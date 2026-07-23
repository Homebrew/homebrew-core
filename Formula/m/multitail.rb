class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://github.com/folkertvanheusden/multitail/archive/refs/tags/7.1.5.tar.gz"
  sha256 "b0c92bf5f504b39591bf3e2e30a1902925c11556e14b89a07cfa7533f9bd171b"
  license "MIT"
  head "https://github.com/folkertvanheusden/multitail.git", head: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cef92b70338d321e70d11dd71dd6103e53abd26f6eb585a199ac0d2a43e02857"
    sha256 cellar: :any,                 arm64_sequoia:  "a4fcadf206a7ac84b0d56153bd1d0a9f24c01f39d466dc16edc2ef51a69e0d11"
    sha256 cellar: :any,                 arm64_sonoma:   "be06268413fcf23e7b7c95362f24d8e0b0bf01b4b956068172e48ba622caac1f"
    sha256 cellar: :any,                 arm64_ventura:  "d764f52508358c4d881e6aa8e0a374c96c9cbd27d292f20cce17e7ac55f5b846"
    sha256 cellar: :any,                 arm64_monterey: "480845b936a309ef633dadd0b1a1eadf90d5704be8799bfb9d05d57aa2fd5d75"
    sha256 cellar: :any,                 sonoma:         "ca9fb55f8bf98257308ea67179d882788d74bb7c1e3cbb1b584eb679f81ee44d"
    sha256 cellar: :any,                 ventura:        "88b234118c438295f556f25b1c651714a7e0fd597f9f124c7025d4066a43c5b4"
    sha256 cellar: :any,                 monterey:       "9c26932eba926fbeda0f8cf27e11b47fcc09a992f31aa581560dd00ca47d6c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ff18f53cd0985d90857495d4444ef2e6490f08e73cefd4c5aaaeb95800cc7a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e5209ad76b3f876606ca6a7a7fa6720ec2f976affd51aaab992c0dde63540b4"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install Utils::Gzip.compress("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
  end
end
