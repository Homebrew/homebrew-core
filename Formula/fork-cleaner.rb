class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.9.0.tar.gz"
  sha256 "81a035274ef44a84232144a3a284c9707050f43ff57260ea8b73670b13e347c8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "61ad94fb8515bf2f85daa11366635f591646ee79225d8c0b2d0f4d6c87c03c20" => :big_sur
    sha256 "7a963849e6b00d64efe10a5193d91d596611fa4e8a4bb9ee49c8000dbe8985db" => :catalina
    sha256 "5d17b463da2d368f7ba3276a81a0edd0f398fea58edfd865bd5f4795b0379deb" => :mojave
    sha256 "af54b2458a786b5d8ad0ebf398b4b5e1d0b335dd496e0d5157e10d17f62dc86a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "fork-cleaner"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
