class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220515.tar.gz"
  sha256 "e054d0c3d0090b2015e9ff5e94a15b452a3e4e1de4588542972cc6c06965537b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250ef1e71e1ad92daf620eb3db2db76b20488612eb1fcf20924848ca0d29e80d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f7a3ca9c1bb5410572325e5fcfe63b4512eba1436f6c5dad280d3887073cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "406f6a75ef631958da89f59c8def5359792210fb7dce1f18a64d16ffd6fe8eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a0773a91102467aabd4f3d4546150f98481a22e333aea44d91f49b7347ce30"
    sha256 cellar: :any_skip_relocation, catalina:       "83048afb43d2820605ce1202c817078cedc51ecb4769b95d9822e5d29421138f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e0ee782d1a17445855b2d432cdb4e844c1fb7a4fc3a92d5e2fa3d908659c95"
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
