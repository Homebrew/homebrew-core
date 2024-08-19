class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.244.0.tar.gz"
  sha256 "a0821dec67219cfcfffee88dbdbf3db7c7513e5ec36a1b1c3c03fd79cbd4e538"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bafc472ae7426dcd649aed0bac5d5411c4cda92f9980f3f041eeb793dafcc4ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0be732fdca2055cad4fc780c5c45964c48acc3d1f4207fe63ee50ffaf2e861b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4992f28e31ea7ca426f599281d74ac9fd0ca052ab4eb04d6daa8f5e4a43d843e"
    sha256 cellar: :any_skip_relocation, sonoma:         "abce398e102cf4115525734cfdd47b4726cab24bd530b267a63fb126a29d388b"
    sha256 cellar: :any_skip_relocation, ventura:        "38dd55ad1550c219ffc6f1563b08201e17304d024555f909b7f5bb6fb6cff404"
    sha256 cellar: :any_skip_relocation, monterey:       "e9c0c435797b50c34d85dd5c32d27ce278a07a5e202c33ca5564683f9d66d4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f11ba53308277453eea3109c9701cb9bf94f0895386782354c157e9f4279e732"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
