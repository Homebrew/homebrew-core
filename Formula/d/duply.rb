class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.5.tgz"
  sha256 "001af2b95e6324da317092ec4a33832ce1ee2caad21216376eecf2d5c421f805"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b438a4e468cf24e66a3607703073e05ddfe9f6b41c8db9ec438e75f08066d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b438a4e468cf24e66a3607703073e05ddfe9f6b41c8db9ec438e75f08066d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b438a4e468cf24e66a3607703073e05ddfe9f6b41c8db9ec438e75f08066d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7b6dfcf4d2d1b4da0c0c3b1ed3675ecff11be1149201931b281f15369b5a5a1"
    sha256 cellar: :any_skip_relocation, ventura:       "e7b6dfcf4d2d1b4da0c0c3b1ed3675ecff11be1149201931b281f15369b5a5a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b438a4e468cf24e66a3607703073e05ddfe9f6b41c8db9ec438e75f08066d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b438a4e468cf24e66a3607703073e05ddfe9f6b41c8db9ec438e75f08066d2d"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system bin/"duply", "-v"
  end
end
