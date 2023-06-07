class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20230606.tar.gz"
  sha256 "4490f203973b59e5bbaa4cbfb8835232f9671dac1b82ab4de882d32a2ad6b612"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec9f423c75799d77ff6232c636195a4f6aeaffd022f578af101df67f79b8e227"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9f423c75799d77ff6232c636195a4f6aeaffd022f578af101df67f79b8e227"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec9f423c75799d77ff6232c636195a4f6aeaffd022f578af101df67f79b8e227"
    sha256 cellar: :any_skip_relocation, ventura:        "759abb842e4c46a4c86ec776666098a4270d3f6cc635dec0a70915e91c451397"
    sha256 cellar: :any_skip_relocation, monterey:       "759abb842e4c46a4c86ec776666098a4270d3f6cc635dec0a70915e91c451397"
    sha256 cellar: :any_skip_relocation, big_sur:        "759abb842e4c46a4c86ec776666098a4270d3f6cc635dec0a70915e91c451397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5854caf4874c75ae5a761c4cb5a7aabecfd89f1775b8f18f4fbe48ea8c3620"
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
