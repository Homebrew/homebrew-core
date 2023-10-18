class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar"
  sha256 "fe68430bbaf01b45c7bf46fa3fd2ab51f8d3ab41e6f5620644d245a29d56cfd6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2fd589bd9d5b78d0320266d1f6001e30e4ca6b9b1e84021d5d9091e066490af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f920dd057755ffe7ffeda8c69132b8eef968197f8afc6d6cb2c635b0ced65d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9f2e503ecd0cb0ffbb7297c91ade88e59fae31c5d9f898f0733e57b86c72020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9f2e503ecd0cb0ffbb7297c91ade88e59fae31c5d9f898f0733e57b86c72020"
    sha256 cellar: :any_skip_relocation, sonoma:         "726f7057581fa4ec0bb607e09ae69c606dcfe9a10a013f95ced20b8da9fa445c"
    sha256 cellar: :any_skip_relocation, ventura:        "54396906b51eee78fa431988387356533e61a69629388aee1a2a534df1776fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb061bd3996f49e3b6ee1848677a1fb1858cd126c810f22bd82dbfe3518b59c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcb061bd3996f49e3b6ee1848677a1fb1858cd126c810f22bd82dbfe3518b59c"
    sha256 cellar: :any_skip_relocation, catalina:       "bcb061bd3996f49e3b6ee1848677a1fb1858cd126c810f22bd82dbfe3518b59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f2e503ecd0cb0ffbb7297c91ade88e59fae31c5d9f898f0733e57b86c72020"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("#{bin}/pickle info apcu"))
  end
end
