class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.150.1.tar.gz"
  sha256 "0485f94705d986914c96c3c107204139a6f23c36e49a2c44779a5e874622a54b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ce77e529e6dbb7ab3d1bd9e7e88baed2c6f9e989f4e81db2dffd662f326e33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7416c71cae5d58b0524e60e0ae9035dee520b095f6c80fad561bc9958bad21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9f12f027e592370ce46055ea6c04fbf6c3dad5607aa7dd5e2a26ee99e5a0b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "96094077fcce5b1641f0fcc7df7e82b7069368fce9e073d2b4c3c32fcfb79259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e63ba373ace10e9c647a7c0f9d1c81df1b65da40d2eee167b0da4800fbe2fdb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2564fa6b4245d993dc03f13433dbac741158eebb474163566dda30fbd58cb79"
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

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
