class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.7.0/miller-6.7.0.tar.gz"
  sha256 "45c86dbb35e326184740eded13d61e9900187dfde72d9c46789d429373c7566f"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f660c35ac5b44237c7ac9661f96e9f390463e65168bf0c60b87ef78050ca995d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52b9ea49217fe86d4fb1256c11d3c2800941a4fa2fc01628cb43d39c217df035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff8723673231b469bfb071b885844157c0be35b90b5b056a3e473802393da30c"
    sha256 cellar: :any_skip_relocation, ventura:        "772230895bd0705ce04a71efdfd1a723363e67a91c9f6f0a9a6791c073faf40e"
    sha256 cellar: :any_skip_relocation, monterey:       "0ecc8d24b18582acec88e09ec02647709aa67bdd09dce229ff7e2c7381abc08d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5538aa063f5551af443f39c387b6ef9a00b82a77c2f4e570fb7fd0ae5a866e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4dc0d22e3b664200b68d08b2eae6dc22fd3070a289de08e9485e85de3360bc"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
