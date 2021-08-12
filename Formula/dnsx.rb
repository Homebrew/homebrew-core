class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.6.tar.gz"
  sha256 "ef0ade0508f0d6d8ed7e80f06e2ed888eaca9837fde513fc801451044b6a567e"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e788a568d8deb8c7f6af6356124dfbebc01d7fd5a1f82bbc2e445945b66b3e72"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8d1d56d6468ffa1e284d1a4930576b27de205767586d489d43bfca77f990131"
    sha256 cellar: :any_skip_relocation, catalina:      "d2d3174056f25eec0a99bdfafbc725c649db5b819a9e0c32bd0cd3d96f69d909"
    sha256 cellar: :any_skip_relocation, mojave:        "068c5fd360dac10c1a516ead00e9625105a94ee81a19c7b8a72592a1c702449a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "606e7d793bb8c893f025442c98cc27c07092aea143660a3f1fe2f5effc7cb58e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
