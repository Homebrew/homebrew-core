class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.5.x/duply_2.5.0.tgz"
  sha256 "355ea48fe2a503f90e647fae5c8ef3f1592d8fba6d02c0b19fd5544401d5b2da"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f7609210b27f57eb67dbb11d4a03e9080b85e193ec67b72af8251d60c6a58ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f7609210b27f57eb67dbb11d4a03e9080b85e193ec67b72af8251d60c6a58ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f7609210b27f57eb67dbb11d4a03e9080b85e193ec67b72af8251d60c6a58ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "37d4318dfc5f052e538d780ed8d0dd23bc4f1e14622a2b5901227994ff2a6180"
    sha256 cellar: :any_skip_relocation, ventura:        "37d4318dfc5f052e538d780ed8d0dd23bc4f1e14622a2b5901227994ff2a6180"
    sha256 cellar: :any_skip_relocation, monterey:       "37d4318dfc5f052e538d780ed8d0dd23bc4f1e14622a2b5901227994ff2a6180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7609210b27f57eb67dbb11d4a03e9080b85e193ec67b72af8251d60c6a58ff"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
