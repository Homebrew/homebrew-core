class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.91.1.tar.gz"
  sha256 "16e648d1180f7adb950afdab5a9b7b88f6b7a3c340552f768cf695fa7b2bc902"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bee5cde829a48b4f8d8c34170c2bdbf7f2e3f3b9f0631fd9233e5a0ec48a6db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56c21c10ab027b7bbe3e7a9f89e9833d0f9a5c38f89852deea0ab32b28bba76c"
    sha256 cellar: :any_skip_relocation, monterey:       "8b62d914133c759392e2dca9aeaf4b144fa6ba81a910d2a74e39d1f1c61328cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "908058deb2874d0e3c6b015b0feea5dc80a7cc78530a174afbc1c707d15a52c7"
    sha256 cellar: :any_skip_relocation, catalina:       "44924b2b85974f31713ebf30ec8d3ae37b71daab7f698582c1e995f4d561b150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be00711ad8333af344c41c27328fc9681527293ccc2e901f8881eefffc9429cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

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
