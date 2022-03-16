class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.0.tar.gz"
  sha256 "5cb53066b689982be0d08322c40a82320888184cf5ee2a7fce118d566261de20"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2678e6d82b7003c305ca44e22c4b6e2da46ff20ee8d3cf2ae6a74158ae33fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42b4549ca9cf9b0efc0f62b85daf134f6d14921d8b930a3b9ff6bbe188bbb3e1"
    sha256 cellar: :any_skip_relocation, monterey:       "af1d97e1025a2df13a3f3016c0ae74dce68c426e653532dcfd3eb7e336b9cbeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9b89bb5e451ec5942a503e239060dc939c581b76adc9ba5160697e3ab9d2f57"
    sha256 cellar: :any_skip_relocation, catalina:       "88e91fa4e8ea1aa59e7f161662477f577154b9efe0a970e588ab812da8663fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b71c7354b8214f70fd4a8117768116412b363b90c193652b6b422b17f3862e01"
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
