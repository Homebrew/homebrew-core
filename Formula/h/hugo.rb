class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.122.0",
      revision: "b9a03bd59d5f71a529acb3e33f995e0ef332b3aa"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b89efaaf6660c70e89e1b0e8e8be5ca0e5151b45c4e1207a9945c84871436804"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9448c2f9f041f5c65e35f5b965054db1d40c0ba1e084beec0a97cca13814ada3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd2f7ccaa3096ee281a7fb62ec2f6f1495e4cdb799b2bf8fe813495f89ed57b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b37aa47ef3a256a4e0d5f8cd33d030f66c0c46b0c1d15bb51c7050cf6e65369"
    sha256 cellar: :any_skip_relocation, ventura:        "133601aba7335cc789a9c285518bd15afb0d123f2be91d05817d5178e9111e45"
    sha256 cellar: :any_skip_relocation, monterey:       "b04edc88a42ee155b00288e84e72d33dabbd4da42b2ea6059b01ceb40b8c606a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33036a60772b6e1b5086ab0069cb6b90de242c6bf25a62a9dd576649e5ab341f"
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
