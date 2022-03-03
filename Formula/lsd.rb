class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.21.0.tar.gz"
  sha256 "f500c18221f9c3fd45f88f6f764001e99cf9d6d74af9172cbb9a9ff32f3e5c7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf151090b2e9b91712ef7e68b49fde1c29df7f297b95befd0a7bb54a5cc31af0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49d300c388aeddf3f8bd5317e8e57e8dfccb58951012c645b21f08b3d44aa8fb"
    sha256 cellar: :any_skip_relocation, monterey:       "efc272c6b18fef9d8bb8aae68fdac4ddda5015ec1f3b9083efbd4fcaac48ca52"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bada68a80bf51a2e53517f5bdb8fa4dd5c7be5c7870805d4f713873010877bd"
    sha256 cellar: :any_skip_relocation, catalina:       "eab4df3f96017b2bb0ccf8686ec43be80375ac087a0e64b06aef5bf86d4272f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68647aaecd3c6a95dd6ef0abc42ed5fb2a609e24616a537c71f0743a837d8ba4"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
