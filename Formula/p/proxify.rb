class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://github.com/projectdiscovery/proxify"
  url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "21e7d9cfa047d66353e98daeaff9d182091168e2385746dbbd0c194de792fbb5"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43240776e0cca25746be42bd5598599c94852a9a8350eecaac7c16f5c1eea114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ccc8da7bc76d1dcac5a26c38701d66d17e47748db1b2faccd16aea943b26f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab56f08717ac71f15def86e44d0c428f556e3f908ac7fc872c75d77c0d4093dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "38d0cf3fbfc6f854c16756dc89363e97b5824c9c414d6f700e330610a61633c4"
    sha256 cellar: :any_skip_relocation, ventura:        "e0e1a3233d78f7127319caec65a875960303d869637b77e0ff4c089bd4d6af8c"
    sha256 cellar: :any_skip_relocation, monterey:       "4571453e9ad967b4d3c17c02c051b015f8f7c96431d7ce9eb614908b68883096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "690625eb2cc8125aa242223b221df8f19311e79a84b7877af6d96847f016a92c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/proxify"
  end

  test do
    # Other commands start proxify, which causes Homebrew CI to time out
    assert_match version.to_s, shell_output("#{bin}/proxify -version 2>&1")
    assert_match "given config file 'brew' does not exist", shell_output("#{bin}/proxify -config brew 2>&1", 1)
  end
end
