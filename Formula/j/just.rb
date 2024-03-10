class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.25.1.tar.gz"
  sha256 "52a77acb3b8ee109a3a3a6dc5f25cad9418cdd009438788098128d737cc537d2"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc1d6d07768d8c5d9e7f49f83dba9845f304de0814d6b3d0f85bc533ceeeaa9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "930543dac7897a85579a08b06f458d6a401b55dfb084712d981109942b79ea2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cdf568b902188b337cf9557963bd2c5f4053f057c41e83a3fb07a4e99e711bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d444195b2655a082e62c09148f776f0dfc274b4a2ff4141a9ef899c4653f3980"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e2af9231baaf2879ca101ee6ca92b46bc15915e757e7856aa35a73573714db"
    sha256 cellar: :any_skip_relocation, monterey:       "36969d8a072ad2b65d14ea6336bbece6923da789c93cda9ae63341fc04c3536f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2700ceeddbd18e3ada3c8fc3397d66f86154faffdce3e0bc37da2f673806755"
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
