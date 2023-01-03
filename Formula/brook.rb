class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20230101.tar.gz"
  sha256 "d131b408102ef6865c64a7cf9d7417308ef3109c79dc627e01bfd665cf80e47c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a250432cbac3da912e153d6fcc93378a586119fdadbcc1375d3ce8dd77081e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc139a88d377c360a1e2883ad2635aaa1b30d9755f815ad1b99f1f29764c55f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89d9637de109834be2bd604230e4ce8646f407d73c0f167d08d046c0d094e8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "b1919a5ee1233a2f00f703c33caa48c7828bcf4e081e2f64d078dc9be6604c80"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c6e3409c8ba543ac314a21a52c1eee44eb366b8c093505aea0ddf9a89a8598"
    sha256 cellar: :any_skip_relocation, big_sur:        "16c7fc735a528ff2b2713912dc38b20a95f814ee0359df2b343062b335985a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393adc94dc610c229c4b77077e7d7de05813beb56af4f7bff40927b2d298f082"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789&username="
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
    assert_equal "", query["username"]
  end
end
