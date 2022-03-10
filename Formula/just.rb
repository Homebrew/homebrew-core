class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.1.0.tar.gz"
  sha256 "b0eaf3c7da507be9ad8e0ce050a10459eeead72b94d50bc3261e3dcda516b03a"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28fb882d1d0002cc330b3ba358f375a32c8644bf0994d0989d10371a31dc36be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e68192eb2c5030fc65971feecce35dd94eb9a1885c2825816687d7a13f8fa41"
    sha256 cellar: :any_skip_relocation, monterey:       "8b1b4c295e11010be4d67eba0bc58b334aadbd0ce1fa346b4991a1e8ad01f037"
    sha256 cellar: :any_skip_relocation, big_sur:        "60242b83beb0779a7f91faad431f4d198528626b9ddbb70503967599079fc789"
    sha256 cellar: :any_skip_relocation, catalina:       "7b3fa10409e847fed0489ade7fc61a0a770f56df16c0477e17490176737c6286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8cda3bd882f6d23aa0893827c389f74cbd35d4f447fd1e7afc1a80ccada9726"
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
