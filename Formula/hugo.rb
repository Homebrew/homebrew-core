class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.104.2.tar.gz"
  sha256 "22ba682f30e4a3e2511662b5b223a15af0272d863d46276a5311cd15588848dd"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ebdbdde069ebc7381b08867e507def2bd953cebdc9e87b3c04a568ac2c34e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f37db36f5a111febaeba709eeeadeb0a840f69096a4b7eaf35e993f81a72b751"
    sha256 cellar: :any_skip_relocation, monterey:       "8a31d9fbc0b231d4ca96da4609b44eae1ba0f633c1cc7b5dcc0de759039e3cc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0479bfc615a27e637dcce875060c6cccc65bfda5267374e5e997c48a6f26b279"
    sha256 cellar: :any_skip_relocation, catalina:       "b19f7f9cc8452c3ec7cae7d0f18718f2b8cd291a2786b98b54ee1b83b191be5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c47bca9eac5800562e2edcda39ebb3c52a61bd61ca89a4b3fa378095b3e479"
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
