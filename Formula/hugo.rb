class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.112.1.tar.gz"
  sha256 "fdc410e4c274102d0ba78fffd158c0ee485fba121c5efd54fe2c5db8fe6ee2dc"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2bf1d47fc2365acd5c5a2e1f9ca63368be401f21ed17ae8e870746007238e8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a68b664f85d5fa4db7fd87889b5960448cef00f5566d2ca279e5e2635218231"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cd992ea5b3227cf535e6dd9909c9fae486ff950176c121ae69c236ab2753cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "286896ffca11831aac15615272fa8b9d8503b9459e32797263ebabdca3181dd3"
    sha256 cellar: :any_skip_relocation, monterey:       "1ec51e2b2d3cf7a73066fe291ad6f2d146aa1db09bd7bf0cf9807f0bd8ef49ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "3846b51f8502bf26687f16d1a9a62fde4e109a6e8219b3b5b639299bbdc82df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e27a6c741a8c73a89d76f1973941972c0461ffa97c96476de87c63bfd4d83ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
