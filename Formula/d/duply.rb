class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.4.tgz"
  sha256 "3cef4b4bb3f6c659eb0ad4b370b089889043965aa27db5413120b2e6e47057ad"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd0f957d98df4e5f1fae93b0c9c2df891f726b50bca438bd8c9b0b81a5085eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd0f957d98df4e5f1fae93b0c9c2df891f726b50bca438bd8c9b0b81a5085eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bd0f957d98df4e5f1fae93b0c9c2df891f726b50bca438bd8c9b0b81a5085eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd7f2c5a1b900e52bc6bbe7ecc0d942f549db1edf0e445cfee02f7934aafce92"
    sha256 cellar: :any_skip_relocation, ventura:       "cd7f2c5a1b900e52bc6bbe7ecc0d942f549db1edf0e445cfee02f7934aafce92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bd0f957d98df4e5f1fae93b0c9c2df891f726b50bca438bd8c9b0b81a5085eb"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system bin/"duply", "-v"
  end
end
