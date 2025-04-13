class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.6.5.640.tar.xz"
  version "1.6.5"
  sha256 "630ece56d9eb3a55524af0aec3aade7854360eba949172a6cfb4768cb8fbe42e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.\d+\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "47f7e484d7283c661836b9cc8418b84c31865c546828f593cca451b4683271dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19232a80ff846e801ac176cbc07b67be6ae337b4b411159f98f3f1510659f982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "592fcf0abcecbd68e972ef3d30f307913f332bd43c44bcf7fa61ebfd19014bc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17602321477fe03dd60ae1cef95f8c28e0d390b360ba5702ebff7eb6c0903713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c26e2866f3b047c5c07ff66e4df5727db8d2f9b92d7ee12232b41c4fc1c8a5ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "8689519ad4fbcab004d4e965475e17b151e13adcf0c34da2cf14798f0f031525"
    sha256 cellar: :any_skip_relocation, ventura:        "a0f47c5a77ea5f44004012fdb01a9d8dd0e265766b82d78ee03abc5eabcf20fe"
    sha256 cellar: :any_skip_relocation, monterey:       "c8573fed1249cc4be686d3b7c3e0be2dda4dfce65f3bebc4516ef7118c038d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "9940ff3f816c8010d064c8a637375ffd7c1358ad60cb5bc6608d312be385874b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4cb2c176c41ce1f4c3611ea8a99f34aff49d056a9cee9ac13c9cb5d4349051f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8a2eae48b82643c9c5e3c31fcdadbf4b8a35d2caf8c2dc3406ebb5cd1f82ba"
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system bin/"fatsort", "--version"
  end
end
