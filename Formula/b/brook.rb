class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20240404.tar.gz"
  sha256 "6eda9a348f9c3555a1c27711e81c0982ea9999bf2878e73cf2eaaee90e8cc2e7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ac140c15664cdcd85034e7142db492a55a01666b226dc8a69f1b4d128397bd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e82e4eaf472ac71592f17609a0606bf537805b15524e7a44c1efc6abd24c26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d8e54063aec7db273d9e8cb905a4354ef9dab34d2437c1750d87157c1133473"
    sha256 cellar: :any_skip_relocation, sonoma:         "a11486105fba038e9fbfe4ca493f564aff16ae81e2f2ddfeb645c408552d6586"
    sha256 cellar: :any_skip_relocation, ventura:        "3e4fb2efc5c76230da2f3a39230a893351fdc6a34ab2dfb8ad2e942054e52e78"
    sha256 cellar: :any_skip_relocation, monterey:       "516abe77dcd1b6f33f34f2af4e32d984d23932941b9b7d56d792ee6cc748ed62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2ac20bb4ee9cc7c5b5aad47649ecb93ab5baae2b6239f3045cb5d043beecfd"
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
