class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.9.0.tar.gz"
  sha256 "81a035274ef44a84232144a3a284c9707050f43ff57260ea8b73670b13e347c8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "035bfa99ac3f594f52b61b7e498d167852560beb119a4d13c4251e79e985df7b" => :big_sur
    sha256 "804504b766150b80ef28f17ac3afaa06dea6a5467a821cb83ce7b3bc199f87a2" => :catalina
    sha256 "d0f57e4cb456de17297f3b1f91824d29b976e7264547cc5ad384508aa6ff2021" => :mojave
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
