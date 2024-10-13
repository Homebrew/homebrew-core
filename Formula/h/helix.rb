class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/24.07/helix-24.07-source.tar.xz"
  sha256 "44d9eb113a54a80a2891ac6374c74bcd2bce63d317f1e1c69c286a6fc919922c"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "aca220707560d244dacaf31bdee297ea3fb06a0f0233950e7f79356d38b8e916"
    sha256 cellar: :any,                 arm64_sonoma:   "294f4104897fbacba617e5a36b03c0fd9b76045cc945b1e9d8724a6fe0b3c704"
    sha256 cellar: :any,                 arm64_ventura:  "a39d33d07ff5d24d1828fa73fdc3a9929f2eb117f69458343474bad381fa3be0"
    sha256 cellar: :any,                 arm64_monterey: "a805b9cf92bea4af28978aa01be47e92b03e33ab00f2b6af59a362c97fae159e"
    sha256 cellar: :any,                 sonoma:         "280dc151440e21232ba4e791875508b89fa21f4bfc1c1c253b018846b678bc2b"
    sha256 cellar: :any,                 ventura:        "213a6db0a612bc716fb13c3ee9e7dd0f791b7d31c00ab24fee45f0909b9bca43"
    sha256 cellar: :any,                 monterey:       "ee239a50e7f7729be3266abe1d34b0468f7bbdb6ed20593946b586e934cd5f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed78a660cc13144074002b31f99d83027702c1cf5043a7a0bfba4e8c09f886a4"
  end

  depends_on "rust" => :build

  conflicts_with "hex", because: "both install `hx` binaries"

  fails_with gcc: "5" # For C++17

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
