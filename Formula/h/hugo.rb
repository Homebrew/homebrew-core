class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.117.0",
      revision: "b2f0696cad918fb61420a6aff173eb36662b406e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa1c5228b4c44c9ea3ea3884f0e806f1f61d2bea662dd06507c287b253fcae34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf265d3ff39f4a288a706bdb59c33cfcb1d7f7fcc61b0fcb950800ddc7ebd9a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca812d7e4ed7ee34fb47100538eee3a617f22c7128cb8df96b99ecdf1359fb1b"
    sha256 cellar: :any_skip_relocation, ventura:        "c4358046479bc547e257ca871401ede61e27daceb5909537e17f7d4c985d3a25"
    sha256 cellar: :any_skip_relocation, monterey:       "6291aff219790d557ccae334f3ba072b5cc1548161fb97f4b56cc3b985a40e54"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e304ecaa1bcc5a07d1c5d44fedc4518c1152a8a4f9016b0d4510fc74b4a3766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ebb2fe7d74469b825e14fe80e37000d6ae03d5f7e8d91d97bdc5881867b7ca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

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
