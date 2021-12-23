class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.91.2.tar.gz"
  sha256 "a749485225d682dee43ea6a0644d5bd2e587c0535508be90e679b21e4553f8e9"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32f51724828e6fb610f63537c9e103a89f32130107dfdcae8f196fa181bd6d16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d63ab3431b9cdc140b32b785ce056db692c49e35df3458c20500d5b25844ab03"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3dbe2ca4b4a78a18bceb64e2bb1aaa9ba456897a561729c92bc4d9360952c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "585860ac079e683c1e256691e30d98cb35d095f0cdc0b3c8670922693e48121c"
    sha256 cellar: :any_skip_relocation, catalina:       "0fbd4d401c24625068cfce3f18e9079309eb342cfabeb34f9d12dbd493336254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bfc501e2c226b75eacebbbde6c2315e99e89decc83c86d72ce187450aea60aa"
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
