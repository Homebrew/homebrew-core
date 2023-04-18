class Lemmeknow < Formula
  desc "Fastest way to identify anything!"
  homepage "https://github.com/swanandx/lemmeknow"
  url "https://github.com/swanandx/lemmeknow/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c2edf419aed5d2f9428d094dad627a6205b18da84ac25bbc2879f0ebc39c3801"
  license "MIT"
  head "https://github.com/swanandx/lemmeknow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e9922fdf7430f284d8805a3b3a9e8f9750885ff3c02d5ac3a672cd03d9ba6df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4da2e6429ec4452909764e4d90109d9a4789ece911f0f6e4cac5429e6c9968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5550c7f941db6fafe0f814a1cec0c7704e96995d8a6090d471102fce30dbbf6"
    sha256 cellar: :any_skip_relocation, ventura:        "1149c622e7fc3fa9bbfb3ae34eea4feef77958c60a778769ef2914c4a31f7474"
    sha256 cellar: :any_skip_relocation, monterey:       "68a7037b81d6ba6a30b3cd4ab8bd629c933a61a82d49f290195c85fd0ad56cdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e3c489fbaecdf25e795b747b2664713c0d2a6e9177cd3d7c4aaf7ce30befdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd6a42c19f17d4e0699a2e6d84a9212612cf546d119f56e4af74dfad929fc32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/lemmeknow 127.0.0.1").strip
  end
end
