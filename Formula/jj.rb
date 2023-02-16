class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "85e73cde738a2b92aeb253ee3a29f113589c19ad11d4244a14e2d0ca5fbfb3c7"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2ebfeaf2fe3777a37fd3ff0aa93ef3807a3cc10b47ec34a5a8a2b76e3b44ac8"
    sha256 cellar: :any,                 arm64_monterey: "5157b26117e39e21a4650919c8396853b68d7e2a7043408da16cf1c682e2d2e7"
    sha256 cellar: :any,                 arm64_big_sur:  "9713d5493e80c9818bb13df598ad2301e308d235f2eddf9d5d93d9b4977d39da"
    sha256 cellar: :any,                 ventura:        "2ba74976081d3b27f36336fcac96e9bad5bca0b4c23d03196798be822b775f89"
    sha256 cellar: :any,                 monterey:       "6cee14853fbe8e7e699f49b837ead1317a280be8d267511454f0d093afbaff5e"
    sha256 cellar: :any,                 big_sur:        "70f7a5c7902ecdfce3d6cbcf565b63d45516da64f251d31ad05ffc4b4b4a770a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58f5e027a53cfaad5ddd3ad223548bec93c7b8ff77d4a275b79eed06e0e111f7"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
