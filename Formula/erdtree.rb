class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "8bf5693e3649def61c3bc12f42a3a019647c4efda4bbaafb13a7bf84de67d668"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01c61810abd065e0ddca0c6b2ebb01df4d7833a8a6bd14694534cfe04544453c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05c7d89e0541a483a3843ad78eb70510a05e67586bb1a27c4a9ac3fe638fe74f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5605089dc3a74bfb972883b3c58e2fe1f87aeb1ff8740915b60fdb7d25365cee"
    sha256 cellar: :any_skip_relocation, ventura:        "1034cc94cff545424ab8dce323a978024d886fa3999dcb8cdc9fbc322b9c51c3"
    sha256 cellar: :any_skip_relocation, monterey:       "b595ff3db4a60397baabd0e7426bb0d3cf21257c7dd0dc4ab2902e5af936ed74"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a90c15586f0ebf4a94850edc7d8f4e9578d95eb33b45081fd9c0fdf5209439f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0696f2b63738a962e4152cb6dd45c09da107fc0040be36df491770b0cbc560c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
