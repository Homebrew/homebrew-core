class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "60b60c469d9ee7fc9b5f8e2bf93312fd1b66ddb57f803a893638b1912d4d83b5"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b0741d12c7fd27e441000588c8f67d5b25219ec354c30d6f1fb71f0895fd21d"
    sha256 cellar: :any,                 arm64_sonoma:  "54b2e32ca7f2d38367f81786633fa378511721c6c2a7408a34518c4d3de2082b"
    sha256 cellar: :any,                 arm64_ventura: "4cedcd31ee0046d2b95a03a3bde145840e61e56eff9c4d8c615ca72f52c293d5"
    sha256 cellar: :any,                 sonoma:        "b14628debc357e0d0fcc2bd0416294addb0a809f0f5be808c0aecae4f0b69976"
    sha256 cellar: :any,                 ventura:       "66cd155d2f35568095aa49aaace7f2ab61e0a0a2db380735971e184d85c67487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5262ae0ad2b26cc424db339d0f1315ef6fa9a51bf38c972896f9525ce768801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7546bccd5073612b4c45e233d0e78f4010ddf81ebc280c8a4e566279ed01f5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    hash = pipe_output("#{bin}/base16384 -e - -", "1234567890abcdefg", 0)
    assert_match "1234567890abcdefg", pipe_output("#{bin}/base16384 -d - -", hash, 0)
  end
end
