class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.84.2.tar.gz"
  sha256 "a3df08d41b953efc0b38c2558c00430b120760a56d38d1b0cdd161a9bef14083"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b74c37d81d099cc019cdef1ecc62a94de79039a5c3bf137aafdb662ffec2d39d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fa4e9ee392a9640f1adc3efb227cea0c0a095bd15e2ea837c81e0c86ec883b8"
    sha256 cellar: :any_skip_relocation, catalina:      "41ec11394dd5af51bc034a14037fec49fb143bb199796ab5c1ef7189f4072ceb"
    sha256 cellar: :any_skip_relocation, mojave:        "c786f9faef0269fe36d8f0b5486d829822d004ef05ba2c2ed396e80d8b5c274e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "extended"

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
