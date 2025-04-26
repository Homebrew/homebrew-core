class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.147.0.tar.gz"
  sha256 "6a4531ae36f71f930b52211515ce6552439f23d110164bd4fa05f28f07574ac2"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10984063c7afd0f43e243aa3c0b9047058605fb0771a954c9fab4b1faca2241c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a84e6f50485d2ffd71e53c5ea05798f09a8ab5339910a5e6ebf082379e8a8ddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4fae5cc30ba9e28b9e3dffc03140496df3639c8955bd71adb88297b6b50e38d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e7361034b5c49726fb691a18070b6c811147067e543b470a87154e1c5385c2"
    sha256 cellar: :any_skip_relocation, ventura:       "0554b29214fe574142274992eaf572300e8af58de5989b13059fa27d64d8e38e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6493847d3214b67cbade6a51d6375fdceb2ea823809748829da58eaae02c6ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084c8c27c4252511c1d11c25678360709e22d88f2bd2b915e82f84e095bc3786"
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
