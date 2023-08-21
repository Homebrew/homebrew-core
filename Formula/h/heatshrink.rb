class Heatshrink < Formula
  desc "Data compression library for embedded/real-time systems"
  homepage "https://github.com/atomicobject/heatshrink"
  url "https://github.com/atomicobject/heatshrink/archive/v0.4.1.tar.gz"
  sha256 "7529a1c8ac501191ad470b166773364e66d9926aad632690c72c63a1dea7e9a6"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f897e27aea76f1c2723f8cca5418f8d1cad173b0457348200b609e452f8584da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c86c8958da5c539b53eb0a34f12502aea411b86fd0bcece742397fc515178db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a1ec3b2cd5dc0ebc16fe7ed2beabdb2aba1c7fd9782d3d7fe5f667f4298b44"
    sha256 cellar: :any_skip_relocation, ventura:        "0bde7796c0ff7e0b7d9963db722a39a69baa5b9d89b975b8e49bbab5a6b246a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e211c2b12e4cfb4ccc65155ec91a03d4b5eaf04538814a7404787f308463fbcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9131daef95de9b3c7fecb082ade54be4b67f8c4ca3f3bce6d18f19b1492078d9"
    sha256 cellar: :any_skip_relocation, catalina:       "5956959544286fc9b6474a0f6df508530431c1632527fa4048091f33f319fab2"
    sha256 cellar: :any_skip_relocation, mojave:         "504b4b64164343217c6852509b59858494ba38ad9b63e7a9b3bb247290833582"
    sha256 cellar: :any_skip_relocation, high_sierra:    "865d11380a3e586a962a5dec0069def43e777f20626bdc5396735d003d90d20b"
    sha256 cellar: :any_skip_relocation, sierra:         "3965350f672040dfec9d2e07ac5f26aa16b324f59d2a762a4faac0930d2de684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff464d4696b56788cdbde22f9ec08015f65626ee0b8a4707fad973fd0f493495"
  end

  def install
    mkdir_p prefix/"bin"
    mkdir_p prefix/"include"
    mkdir_p prefix/"lib"
    system "make", "test_heatshrink_dynamic"
    system "make", "test_heatshrink_static"
    system "make", "install", "PREFIX=#{prefix}"
    (pkgshare/"tests").install "test_heatshrink_dynamic", "test_heatshrink_static"
  end

  test do
    system pkgshare/"tests/test_heatshrink_dynamic"
    system pkgshare/"tests/test_heatshrink_static"
  end
end
