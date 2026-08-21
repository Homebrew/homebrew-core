class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "79a1ba318d309f4e74bfa74258b73ef578dccb1045e270998d7fe9da9f43a50e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1e609e7589f355b608db522a0ea0f645093f68d2b103919fe0a45dc155b305a5"
    sha256 cellar: :any,                 arm64_sequoia: "f46a8643bf1b9c29b01d1fd3a7e842adbb707bb167fe939cf35f9516edda9844"
    sha256 cellar: :any,                 arm64_sonoma:  "d11daa75a18bab575cef615a79d679d710cf6213c1cfc060cb7b0c55976e0612"
    sha256 cellar: :any,                 sonoma:        "f3f23539a6d31e0c7d0576084965996aaeecfd61a6c055163fc0214fc9869ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd4c766589bc8b4f73d33846a7b895536071694917d559e551776e6ba48c5d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55200ba7e7f92b5491db32eb807a08718ccd330bbc5d3fbc702e561bc5abc89a"
  end

  depends_on "xz"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
