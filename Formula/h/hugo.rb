class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.147.7.tar.gz"
  sha256 "f9d2e4c85b2d7b1d9ca11e5606973b56717285bbedbb4008afccfd6378d23f52"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676a9287695d34afe0f075666cf5751dd3c05e88cf0eec01a70b58e6c4f667be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa231b58301e693f13f4f120cb350bb88ac0bf0c1c7aaa3e2b9b349e84570db5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "442b3fc42a6692e288611aa5c38cbc6ca846e3a2ddef6000d80d02ed759aa383"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f97f87e8db7193b8c1a7a7183fff81073032c5947c548dc3c6dc681f39eba4e"
    sha256 cellar: :any_skip_relocation, ventura:       "2f5b5ee6cf82d1c7c42c9344f5f5946355952e49f887f1fc5133f2a78346c522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24fe530593b04d1dbfca0028c7f0f9181cf14bca98c4e8038061d5665db05d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62505804e4007eec1c91be75f3386047ba3b4558d77c589bbe6926e86651e72"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
