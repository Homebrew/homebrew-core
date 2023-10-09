class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.1.tgz"
  sha256 "0acf81f1ae5ae520e614b2cb3e5a6ff313afbee2652b8524da69fb4db34099a5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f979398a92a19ba14d8ae774c3b30fec2acdddd4d7d3b04f712d691ffbfed2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f979398a92a19ba14d8ae774c3b30fec2acdddd4d7d3b04f712d691ffbfed2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f979398a92a19ba14d8ae774c3b30fec2acdddd4d7d3b04f712d691ffbfed2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f547d07f73f0411eb165d8094ad05e19dd562ef99387003cced2f34916e060f"
    sha256 cellar: :any_skip_relocation, ventura:        "4f547d07f73f0411eb165d8094ad05e19dd562ef99387003cced2f34916e060f"
    sha256 cellar: :any_skip_relocation, monterey:       "4f547d07f73f0411eb165d8094ad05e19dd562ef99387003cced2f34916e060f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f979398a92a19ba14d8ae774c3b30fec2acdddd4d7d3b04f712d691ffbfed2b"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
