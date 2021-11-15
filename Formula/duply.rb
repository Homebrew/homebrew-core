class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.3.x/duply_2.3.1.tgz"
  sha256 "f044f9d4b81891785212f856ace2064e8a08da19330587d580a5c233575a3091"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84068ad28382385d0d2a73ba47ec81d03da0b4e02aa715f574d01b538727f827"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84068ad28382385d0d2a73ba47ec81d03da0b4e02aa715f574d01b538727f827"
    sha256 cellar: :any_skip_relocation, monterey:       "9b8892466a36e8f58b5148c6c4770187266961364d8dda1971cce8f78f68da72"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b8892466a36e8f58b5148c6c4770187266961364d8dda1971cce8f78f68da72"
    sha256 cellar: :any_skip_relocation, catalina:       "9b8892466a36e8f58b5148c6c4770187266961364d8dda1971cce8f78f68da72"
    sha256 cellar: :any_skip_relocation, mojave:         "9b8892466a36e8f58b5148c6c4770187266961364d8dda1971cce8f78f68da72"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
