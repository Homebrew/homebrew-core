class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.148.1.tar.gz"
  sha256 "1fc153999cf7ba7bca88a85a75a30951587c8741fa742060ecc5c21c2f84a24e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0c79e6edc42f9b3b849a12c5e6f1b10376efa4948d1d25d1d0dbf16fc3049e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712742ae973c0506791fb0238e054f8d8bee8a53cf879d1b47a616161b81e605"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83d081b8d607194e59a55e31b56e09f51b640e7a3728feafdca96e9421c1b41e"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b2391b82e7fb021e862e79da975d4f46c3b35e4cb48672e640a2e4e80c8d6e"
    sha256 cellar: :any_skip_relocation, ventura:       "f8feab240e23117c14faa3b7b3d4af07257b939b9e7352834476777a81a85b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8eb3310962fa24684aa493cb82abf0bc74c5c35fb896fe6224495eabd49cd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32405b0adb8cdeb511424226da5e0126ed08d77e5c9c1ce518de91777eb57951"
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
