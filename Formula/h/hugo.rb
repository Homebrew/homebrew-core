class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.143.1.tar.gz"
  sha256 "2ee3607a46208a178c2291a935862ac9e88fae2c47291e87231cd885236a9cab"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f490528005dc20141728f93a9276a7951a21929ea2d155c2a459ad516ec8b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da57e4c081221c60df6cc11eb274bff2858a3b7f26a7dff78c4bfbbe4f7867ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1da9d68efed840c39e4f158656d49c4d7194c9976d05eb13b4e95a5710f62883"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0a7bf18c9e4992e2eb6f56fdb362b1a2069f3988109e605042012cafa360ca6"
    sha256 cellar: :any_skip_relocation, ventura:       "4f4a9d6a5ec9b3e49ec92229927a74dd03d080a4712c20af5abc237687acac98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50177c7a2c7a2a7c9483290bc56fe139be05c16f095618b17d90234f9bc8848f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
