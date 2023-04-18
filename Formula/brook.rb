class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20230404.tar.gz"
  sha256 "1b9a7c45dcc7935d1965049464c664e634cb6283d211208d8ce519138915c0cf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7099ffae2fa020047b807f20ae4bc20cec66a999b10f174f56440a9e6008586d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a4892d949cdd29e10024de097cfe166a23221bac68148e730a7f5c37617c69e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae2f49b855b8fb004d8c8a94164f5997d7fe0415b5bd35c15b43ae7986a3b571"
    sha256 cellar: :any_skip_relocation, ventura:        "b6441dbcbd14c81e1caec32cb3114f81e68cf20b67468526ebfe41d2ca8fc909"
    sha256 cellar: :any_skip_relocation, monterey:       "33af1330f942922ed434245969bd10afb30aa98c8a465519737a8f7b0cd9d405"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2546c1da49226933327aea300b50ffa1a354e2554dbc765c6ef667c5503ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0f0ce36ffc479f0dc9fe324fd612420202f06f618188e56210f8a94319d438"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789"
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
  end
end
