class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "5aa957278bf6c0a1c30b8bfcc481f92ba338d8c93d7d2e3c233581a7055d3b86"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe5ffeb093d39bda9c3cb87d2587360339d87ecb531185f20baa4ce5db3be5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a39cf4de45c620de07034572c78f1934fe794475a01fcc4ab71f807360bf116d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d31de5c8f147befe119c16e027ab4b193005bdf1fd53952e8aadea895e31e6a"
    sha256 cellar: :any,                 arm64_linux:   "9b112852d7f0ae5c137f12cff68052b57e70d745f92f8b4fd24e757d8ef26156"
    sha256 cellar: :any,                 x86_64_linux:  "cf7caa5f26f14d0d6c875193f6d8743a95ae49a5a8da886be67c5a59b81e4d19"
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
