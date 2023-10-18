class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20230606.tar.gz"
  sha256 "4490f203973b59e5bbaa4cbfb8835232f9671dac1b82ab4de882d32a2ad6b612"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8906b156e46fe120c332669fb38a9c0e401b70089173ddeef03a982210690a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "545d4d40b00c8046b78c3db7ea4f58860e615dfcc852fb876acbc93b57ca25c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc4ddadf8a89af7569b54aeafdf2138601bab81cfa7ae6a4db56087c8914305d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9239e17a226fdfcc053059d0e8165ccb3ec4c41ee66a98d45de873786c66088b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbe3bf0bbbaf45f4f468f758fde6557c02249f118f800c098bd8ba53cf02cf45"
    sha256 cellar: :any_skip_relocation, ventura:        "87d006e6916613366cc87b68219385cfe326d91deb6984f440064d5ecd09f719"
    sha256 cellar: :any_skip_relocation, monterey:       "ab1b1252075be3283d66b63db52e8ec286a497464382cf5c761a04e4bf151f7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7dfa4b5d67cf7f30cca218baebc1aabca00cbced98098f3b96e24fcd4bc689c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03d317c85e8bec7ece9ed2594aa763d544728b17aaf60e8eed22c299828ff908"
  end

  depends_on "go" => :build

  # quic-go patch for go1.21.0 build
  patch do
    url "https://github.com/txthinking/brook/commit/3b8488e9138393b63da3a1f090e0f0fb109f12d1.patch?full_index=1"
    sha256 "8974cc16188269daabd84950aac061cf3af827bb1d9a713c66647511011829a7"
  end

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
