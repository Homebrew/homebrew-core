class Fastrace < Formula
  desc "Dependency-free traceroute implementation in pure C"
  homepage "https://davidesantangelo.github.io/fastrace/"
  url "https://github.com/davidesantangelo/fastrace/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e9787fa43b6b95af8e439674a73b107b9d0357bdf45f1ffce8408ed2164a44a6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "205dc56114d097ce1a80471d9324bb143dfb4caea7e190c970a5551777ec1b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea024f88812865f8ffd2d0f24a5bd85078156dbab5fc8017512d1f3c8638ada5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e985184f285ec8ac2627bc20711f3b758bd332042c4ddd86d067c5112971a057"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4280724b3780151ed4866a1f818961f73a4627b0c1b3e766fe191a299cea3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b17543f14876d7f41617c7f9bcb77319870790682f01612b4a102a8f3850cd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38421bfce20372075c51a7b1d1b3c992b3fe164ef837e064852e52df4773ead2"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastrace -V")

    assert_match "Error creating ICMP socket", shell_output("#{bin}/fastrace brew.sh 2>&1", 1)
  end
end
