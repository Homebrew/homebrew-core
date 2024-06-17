class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "71ee39510c8c687254315ccc1aa5de601a5e2a2554b6db843f3874c12415a77a"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71adec1b444f7b121e2cc126a876d3ca84df3a8cbe2dad781eac1b7c1c8c0736"
    sha256 cellar: :any,                 arm64_ventura:  "581c0cb53c4ec53655015c1477a749ae53f63c18ea5b4c56cd28ac4c42fcaf97"
    sha256 cellar: :any,                 arm64_monterey: "870a9f826384af1e7958de7cc4577c4a7bc536f25b27c70d377685a3616df453"
    sha256 cellar: :any,                 sonoma:         "aa4c9cacb0c6cbeb386a0b04470c4f184b281f32ab9356e0067897b6153a71f2"
    sha256 cellar: :any,                 ventura:        "39b4895bba7a1ae5b3b50ff3fa88297e77085ab97f8f4a45bf623d7264e70644"
    sha256 cellar: :any,                 monterey:       "bb6d45b3c3102d73a79fa28b0ee7345eda0b64f9663d0e0046f434266797831d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df8dffe60c9b43d5192bc163037d3ebdc9cb4bb7020651aa380d8838db92d5f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    hash = pipe_output("#{bin}/base16384 -e - -", "1234567890abcdefg")
    assert_match "1234567890abcdefg", pipe_output("#{bin}/base16384 -d - -", hash)
  end
end
