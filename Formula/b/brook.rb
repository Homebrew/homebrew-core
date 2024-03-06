class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20240404.tar.gz"
  sha256 "6eda9a348f9c3555a1c27711e81c0982ea9999bf2878e73cf2eaaee90e8cc2e7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32ef30e3fe3125fbae237f080cf4bb1564b853fff23a4d02623ed760531c0fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3038ba4d9da0278a06985d7ba6992e64744b7bc18a4273fe0e0afb9a88b44d5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736c43a0f7e46e4aaffb7ebe62633b4cd38f73fe1b4f13e3f1a99953bc0092ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "2231ce59fe4c23ebcbe766a24b51327401de97dfa703d5ae9148d52a17644f95"
    sha256 cellar: :any_skip_relocation, ventura:        "264a76174748962560b477e02775ac4817a407838ca394ca52970092b761869c"
    sha256 cellar: :any_skip_relocation, monterey:       "40ebd6d7ac1b861481fd386e8c815ae294858d5309046b7e440dde5f8aa5e549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64c29c66b6170ffa67c29751a6046fc7e18ec8dd55f74475f4290e4a317d743f"
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
