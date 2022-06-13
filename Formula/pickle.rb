class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar"
  sha256 "fe68430bbaf01b45c7bf46fa3fd2ab51f8d3ab41e6f5620644d245a29d56cfd6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9f2e503ecd0cb0ffbb7297c91ade88e59fae31c5d9f898f0733e57b86c72020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9f2e503ecd0cb0ffbb7297c91ade88e59fae31c5d9f898f0733e57b86c72020"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb061bd3996f49e3b6ee1848677a1fb1858cd126c810f22bd82dbfe3518b59c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcb061bd3996f49e3b6ee1848677a1fb1858cd126c810f22bd82dbfe3518b59c"
    sha256 cellar: :any_skip_relocation, catalina:       "bcb061bd3996f49e3b6ee1848677a1fb1858cd126c810f22bd82dbfe3518b59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f2e503ecd0cb0ffbb7297c91ade88e59fae31c5d9f898f0733e57b86c72020"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("pickle info apcu"))
  end
end
