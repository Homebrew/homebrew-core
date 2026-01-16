class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.6.tgz"
  sha256 "0d24a78df6dc81622e59a03ee21eddff41eaa43a17aa424ec866a9617e2bb4fd"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b48da865cd1504a00ea027655cc144227ed1fe6b200855b959e9836d281e3a6a"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system bin/"duply", "-v"
  end
end
