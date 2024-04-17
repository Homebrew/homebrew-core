class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.23.10.tar.gz"
  sha256 "51a26349f637452fef8d808fa5ad611befd49df0bd32779ef57ffe14b37d9e2b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "525b13c310c7dd5ea1f19ca776e7b1d008e2ca9ec35aba79390d1b041cc7a05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "525b13c310c7dd5ea1f19ca776e7b1d008e2ca9ec35aba79390d1b041cc7a05e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525b13c310c7dd5ea1f19ca776e7b1d008e2ca9ec35aba79390d1b041cc7a05e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ee823d9a6ab958d0003bf4c3a83064dbd2e354e0214eccd3d2405fc20f8668b"
    sha256 cellar: :any_skip_relocation, ventura:        "5ee823d9a6ab958d0003bf4c3a83064dbd2e354e0214eccd3d2405fc20f8668b"
    sha256 cellar: :any_skip_relocation, monterey:       "5ee823d9a6ab958d0003bf4c3a83064dbd2e354e0214eccd3d2405fc20f8668b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be3f2de4d0e17f5e16dbdff10a66be08071f6483bd96e7173322b32c76386a2b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
