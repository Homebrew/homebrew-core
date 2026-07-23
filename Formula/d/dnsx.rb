class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b4b2d8505c2be30181060a05f126a90ef5211c489fa437236172046b38c6ce3b"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b601d480a7d6a35cad9772695fcab578dfda1d765f1cbc6a3cee623f6649e6e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281751f9bda871ea1e2e34f39ee248a8714288e79773c2f213005ca35ee5f9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5bd4b47ca2780f4197a6c01e41d4be788ceeef7147d0cdddae9d8e53105b034"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb715b07a840a1c7d515f553eb3152a515ac3b55081f84d768c82470202ee522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10616c5691c39b850b77c366ba92e18a3439f5b96e5a2776b1e756df657713e3"
    sha256 cellar: :any,                 x86_64_linux:  "b97c34dc1e1b63ce5493b987d8878050bc0daa55617cf7e9f446af59e28f7bda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [CNAME] [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -no-color -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
