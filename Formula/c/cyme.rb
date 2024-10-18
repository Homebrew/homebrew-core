class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2b97ac1560ec96d28be21c1dfda62802c0149fc445fa64bd9df4da9bee8c9f16"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca9ef0ddd36d38c3c4088020ac5ac9acf934957917157cfcf05543c320ec7d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833f65766b9758a7bcdc9135a33018b1b57aee08cc5829a321fd4b729f792a05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3932cec2d04cd6ad8c9a6369c9bb9e18dcd56ce26a788c5f89bfec37bd92ddf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "616a6d487eace71b7d868d566fa3fb4f51ee8faa41c53b788b147d078c4ac0a6"
    sha256 cellar: :any_skip_relocation, ventura:       "8df5a7571141f57b860b9030780db466b749250744174611fc50a6cdb8d5d9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf58cebe16b7514616d3d877042c07438572553eef7f0d63c3f9987263bb96d"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
