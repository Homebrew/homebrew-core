class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.7.tar.gz"
  sha256 "82b72d869933720954ae0c3b4a87a1f02ce1369740c6a254a23f4b433b85cbfa"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8549b5ce5c749ee8929cb2d36b8b7249285ed30c8e5b08fb503640c80b23a226"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96076a417687dea3c6a57fb0ead22b7b311be3ac3aeb61dabf2ccafc3eb3dc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "25ef0b054e4f42373a33bdebdfd6bbd1c9070573f1f2a847b8cbc377790e9c3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "552301915007655359d77425fb1a85e1b8e4957306a98ecb21360d6231582851"
    sha256 cellar: :any_skip_relocation, catalina:       "200505d617c00b251526d4b7b35acf153ff6bc4128efcf9df15a60899af788c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7606e0ff7365b42a61c87cd70cee0d1cff578c957ef4885d13906b89efb22045"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
