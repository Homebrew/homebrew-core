class Heatshrink < Formula
  desc "Data compression library for embedded/real-time systems"
  homepage "https://github.com/atomicobject/heatshrink"
  url "https://github.com/atomicobject/heatshrink/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7529a1c8ac501191ad470b166773364e66d9926aad632690c72c63a1dea7e9a6"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e516025ca4b7b5efb7e5aeb7f8977a7b2b09be3cdcd2d41a4f430a70c7b92b5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4135d8d01abb01a3864191897728bddbc0791fa9356aa2537eeab61bdef9e1ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceb0d2e8dff933f32c0aae21c396d5f2ea1bbffa163fced76f09e1b8b4680df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f897e27aea76f1c2723f8cca5418f8d1cad173b0457348200b609e452f8584da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c86c8958da5c539b53eb0a34f12502aea411b86fd0bcece742397fc515178db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a1ec3b2cd5dc0ebc16fe7ed2beabdb2aba1c7fd9782d3d7fe5f667f4298b44"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b8841b365d74adf6e4300d9d7bf092fd6c3bb3badace8636688fc6dc7debe24"
    sha256 cellar: :any_skip_relocation, ventura:        "0bde7796c0ff7e0b7d9963db722a39a69baa5b9d89b975b8e49bbab5a6b246a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e211c2b12e4cfb4ccc65155ec91a03d4b5eaf04538814a7404787f308463fbcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9131daef95de9b3c7fecb082ade54be4b67f8c4ca3f3bce6d18f19b1492078d9"
    sha256 cellar: :any_skip_relocation, catalina:       "5956959544286fc9b6474a0f6df508530431c1632527fa4048091f33f319fab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b403c35dc1c684ff7fd3c7bad6e7b3724c458ba77537c7208660a0c0cd2986fe"
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
