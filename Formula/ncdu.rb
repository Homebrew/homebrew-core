class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.0.tar.gz"
  sha256 "66cda6804767b2e91b78cfdca825f9fdaf6a0a4c6e400625a01ad559541847cc"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68eb33234f67d014f1bb2edfd2750df4b96398af51063b135dd7c19de2caa8ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "110f61c5159ce8982f2086aebd7e55a1631c958c88fd69eec611242a83bd4577"
    sha256 cellar: :any_skip_relocation, monterey:       "d99f3365fc9733b3274b45e6312b933fea3847e89f0bcef401ed10805c35e5d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "af3c3320ea08a93b0cb7bd260a297305d7c0283f8a9881971ecfa2dcb5c270b0"
    sha256 cellar: :any_skip_relocation, catalina:       "b201c2573ed203bbd41c801be8d0b63045e33b36b601bcf6b8c03b5598c9301f"
    sha256 cellar: :any_skip_relocation, mojave:         "4f0851785b40c0035a3d60687bdb180d46f8ec364508220c36bc40dda90ba25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c1a3244bf54b0ea5246bfa45130f18710f4943a30b897c9c104435585d26ca"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  uses_from_macos "ncurses"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
    system bin/"ncdu", "-o", "test"
    output = JSON.parse((testpath/"test").read)
    assert_equal "ncdu", output[2]["progname"]
    assert_equal version.to_s, output[2]["progver"]
    assert_equal Pathname.pwd.size, output[3][0]["asize"]
  end
end
