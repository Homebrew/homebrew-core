class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.23.tar.gz"
  sha256 "6c72449451464a4a8db5b4899eea1096388b6b68afded99a512f17fb1d40c226"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cd8b973ee0cd54c8819053fb492227024eed445fa605752c957f7e37b1b75e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ffd0a64e73a39f68dd20055b95a0752484854cdbd315c5d5491d19cc59f99ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2983c639f33a4684f2ab250ef85d11e120b8ac4d23bf841f66c28b8f7b86ef2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5408b7c27c8c62755126838c4ed7a61fc87e37439ccfa2c8d7a97471ed7c09aa"
    sha256 cellar: :any,                 arm64_linux:   "4833fad3990d2a0c7fa92ecb6867cfda2b6c38cf593f2790d51c410624bf7128"
    sha256 cellar: :any,                 x86_64_linux:  "79c90d93ab8ed716abf20f8e8f655501eb9bf18218afd31a5811309cc1efcbc5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
