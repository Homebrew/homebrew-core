class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "9c16d269c83a628d38ce0e02f2759b5aa6d55d81d20f4f30383191d365e53b73"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "960c0f52852a5eb5dcf84ce747fc0fa1d15855e3368d4f45e3727cd4c622a881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a0a2757ee4bb10b68c12d5b5f6fc61b6909676bef563b4880d393833643f270"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8e32733f171c219b271c89792ff1f10f1c63f3b3e7fd0d17dd60d754dc35606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d4eea4902eb32d67d228e1dc92342d36a757550bd81003f984c4560eab41df"
    sha256 cellar: :any_skip_relocation, sonoma:         "a24ad8b9063f08fcff5290f04179b9d78942b1dbc4101334af5c254cfa4ffa01"
    sha256 cellar: :any_skip_relocation, ventura:        "d684a92cf0815b40687f077abeb7841f767ce7a30d2933dd1adfb1281a2a0502"
    sha256 cellar: :any_skip_relocation, monterey:       "87de803d80e60ac017c80c55af81c2ceac071af61d83d85aedda80db305fead9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4021b9020af4f5c79f2af48b72ee7ce84b7647ba2dd509857cab7da377ec9e9b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/code-minimap.bash"
    fish_completion.install "completions/fish/code-minimap.fish"
    zsh_completion.install  "completions/zsh/_code-minimap"
  end

  test do
    (testpath/"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}/code-minimap #{testpath}/test.txt")
  end
end
