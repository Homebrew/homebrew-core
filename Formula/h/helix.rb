class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/25.01.1/helix-25.01.1-source.tar.xz"
  sha256 "12508c4f5b9ae6342299bd40d281cd9582d3b51487bffe798f3889cb8f931609"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cca895da8d7984d1dc974a69c1cac38111fab2b7c32d5f0bc66e919dbd2bd4a6"
    sha256 cellar: :any,                 arm64_sonoma:  "b2e86d4e5e3a822615d9173afa64d0de2be5d97fe2fddc7dc7d18a974344bd75"
    sha256 cellar: :any,                 arm64_ventura: "f5f20d49f3a8c130001741624e440fd9f80335a5d64ef331ae2ef80da48f8fd8"
    sha256 cellar: :any,                 sonoma:        "3bb3161910930c9f2316b6478a166432b22abd664a72fc5f493e74d705f4ac5e"
    sha256 cellar: :any,                 ventura:       "42358aa662d5ebf73dd8150e83822b6c347b2f73a7f612bf36100240c3364761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100f81c5b8b2abe845d92ee08456b2c2e82bebeebb2a59326a6c18f3902eb298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d890c7a8eec62f5c3864bb272bfdedb09bea2c1b9523f34545db607b353ee88"
  end

  depends_on "rust" => :build

  conflicts_with "evil-helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match "post-modern text editor", shell_output("#{bin}/hx --help")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
