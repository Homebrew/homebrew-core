class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.108.0.tar.gz"
  sha256 "dc90e9de22ce87c22063ce9c309cefacba89269a21eb369ed556b90b22b190c5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8094c5fd7847a9f8bb146578392ae60ed0e6f7fb47f4d5f3ce40fb07d9c2925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d5655c87621f8aeb67489806fc24474876dfcc02cd932acced539890a1a5039"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d41d8af7990c1426e44fb3d4f194545b18df0150e153b34d515aec3118d68d52"
    sha256 cellar: :any_skip_relocation, ventura:        "6e00a37f952ad854c8d1f3206a12b0566f9af16abd0facec3d05b8c4cb65cafc"
    sha256 cellar: :any_skip_relocation, monterey:       "e53bd439f7763013906e2a7a993bbbb10859fe4fd1839745dc8e87fec791360a"
    sha256 cellar: :any_skip_relocation, big_sur:        "94fa5e5d60cd28b8481a9d91c0cdf2815abd09b1f5f044187f44306cb29e1581"
    sha256 cellar: :any_skip_relocation, catalina:       "b7caa2b21c631fe493fe56f493e797630b810095a97100fe179ff702bb5f8929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa07b9cfe2d4e30360a30f9ce88bd42512ecc5172acaf5b71f2646d6264fad1"
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
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
