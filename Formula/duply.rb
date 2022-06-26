class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.4.x/duply_2.4.tgz"
  sha256 "0c2ae9de8fee93391f9d568b6c82bce1b9989d7bea2acbe59069f718963788d8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6a9be8ecb4a49a4f3ea7f4a0a79546d5731491379fe0e13adcc57edff85fe35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a9be8ecb4a49a4f3ea7f4a0a79546d5731491379fe0e13adcc57edff85fe35"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea9eb0faab5669a11a13a37b6c3a0640f31671b4a1835bc34ec3622cdd1aea7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ea9eb0faab5669a11a13a37b6c3a0640f31671b4a1835bc34ec3622cdd1aea7"
    sha256 cellar: :any_skip_relocation, catalina:       "1ea9eb0faab5669a11a13a37b6c3a0640f31671b4a1835bc34ec3622cdd1aea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a9be8ecb4a49a4f3ea7f4a0a79546d5731491379fe0e13adcc57edff85fe35"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
