class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-source.tar.xz"
  sha256 "2d0cf264ac77f8c25386a636e2b3a09a23dec555568cc9a5b2927f84322f544e"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f0f62bb6efba768f5d1f2e39cd060be9e17d35704c66597955da5bb3a898c25"
    sha256 cellar: :any,                 arm64_sequoia: "55a17081c4827c430ac891d6d60ed6c88f8ac698727f70467d879aef85f40e7b"
    sha256 cellar: :any,                 arm64_sonoma:  "b0af62e33605ad1fd05cdb6ef8c978a71cc714299ae12164d1d09aa71f6fa3c9"
    sha256 cellar: :any,                 arm64_ventura: "9a37be124a4fd1c03b74c965a8f0267d112af349d24b7df90f0dc8f7db9c9b36"
    sha256 cellar: :any,                 sonoma:        "0549f3a3483f52e6f4cf91d1eb5d0bbc7337f8306cce31c33f833ce41acbe1b4"
    sha256 cellar: :any,                 ventura:       "860969afdadeda30a99d0bffce48ace7b9e8c25bd8d8b03bc734043268c96955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb65655cfc088fb01da162a60ab75b419bbacb4f9e262c3be09c4193c382b56d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c25fb6e1058913aaeb3b39e024bd7c917ceb6bb701ade5ce9cfe2e967113363"
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
