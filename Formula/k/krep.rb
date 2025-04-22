class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "99f17d33577861cb2d445345b159652f7f32bbb7d070314ca685d4ced74f2a81"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "053c2b657d16d0c263b9e88f4d5ff2e6a7fa7a03a51397b14ed4d2035b27650b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da42562f8dda54c176b8b581d7265f9b38b0e99ac6f6b8a2614124bf5d426aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42b4c1f1cd9bda15f6c719ccad631a5e2717b9dc0b7dbd59e1aa200bbc92e823"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a070d044af9aa23410e8d74f96cb3a8a4f12e2ffab19f6f7a868940f529ade"
    sha256 cellar: :any_skip_relocation, ventura:       "bff2901536aa00debb1f61ca555cbefbc7f7f702ca3e68d4c0fcce9dfc7b2fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4989da74e5e6853ae5bf7181b98bad9c1b847468fb0d7d174c5b4e285bf2ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4d8a6520e235f820932cc8cacfea508806967ac243bde9905d001ba7cab6ed"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
