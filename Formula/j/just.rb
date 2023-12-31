class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.21.0.tar.gz"
  sha256 "1421c6bbf80547b6d270a918e1143efd2ab37d80078db606a51a0ef3a8a8f771"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c3fee99f121f399900687d9133fd06b431dc952287aeb07fe92bef264391625"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8174e614869390028740fe213d3fa8b0cccfb2bf8743bc9afeb67e778d3d04d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cda7513069f6744c61c444827bc5aad7cf6a0e20aabc03f27ee2dcebe20a984"
    sha256 cellar: :any_skip_relocation, sonoma:         "844d9641b0eefe4fa3511d7ce2f3275b794ff6fe0daa5a8394e2d42dce35f203"
    sha256 cellar: :any_skip_relocation, ventura:        "f48a0b98cd087d82dc04c5491b743e2c83e5c182e8de32d086da0a0be432bd2f"
    sha256 cellar: :any_skip_relocation, monterey:       "679262794e72ffec7cfea00ec1fbec07b6960d6db4992fd9e75fd1264a3fc67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2da19187a6d39aeb0ce253947492abcdfb698f9ecaec1364273886a264a1c3d"
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
