class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v9.2.3.tar.gz"
  sha256 "c160fd30281d2aeb07d0101758f2f592dd3c6a23370417d9c6bf1efb5368a7dd"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
    sha256 cellar: :any_skip_relocation, sonoma:         "10b735f6bbfa0c30b7208446d8f87804cadca713dba7a740d8fde2bd4c363583"
    sha256 cellar: :any_skip_relocation, ventura:        "10b735f6bbfa0c30b7208446d8f87804cadca713dba7a740d8fde2bd4c363583"
    sha256 cellar: :any_skip_relocation, monterey:       "10b735f6bbfa0c30b7208446d8f87804cadca713dba7a740d8fde2bd4c363583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89304b0eb5dba92060a594d9761699fd334efd4fc884df2fbf4afa476e55f36a"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
