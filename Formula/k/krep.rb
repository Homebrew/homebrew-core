class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "058d02e9a34861b92695073ccc3243ca79bdc9b0dcc5b9e798720a22786d5ae6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff4efa02ebb3322d57a51f2476e7eb2021fdb15f2db95d5fbd570cd497f88901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d5676f6811579cc52a7a0fc99aa70a455f4caed8dfe574dbdc6890b850c5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43247aabbc75a8f3e0ee1b0ed82897d10a9fc32857f03df80626c6c41212c009"
    sha256 cellar: :any_skip_relocation, sonoma:        "051df7b22c054e8f4e7a8e985148a4c90c610123d182e05ff31a70e59322fc41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f63521b7bff474b94707f701b813037da0eec83dd580cf94f238fd04f39c66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "764f707d98401a8f024deeed5075c84639f12852cbea7c29aef6da2161901029"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
