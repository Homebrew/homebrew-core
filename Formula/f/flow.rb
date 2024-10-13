class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.248.1.tar.gz"
  sha256 "40d332c007465036e4544eb97b68ca86251fd719f2fd069a76bce1e4a19eb64b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fed6af62695341ed2cc75f58b78415b678066f0dccf8431ad97d516dc607c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b69659c81cca0c9bd4fefecfb2c14ac1504cf32c0e463073d899e56367a9e2b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef4c69cc5a09855cd16bfa92be8748727351194ebd109681b92316558051f302"
    sha256 cellar: :any_skip_relocation, sonoma:        "9191670f6eced3fd2a35712d55c228edecc9bc50f67deda1274e6d0a9d7d3cbb"
    sha256 cellar: :any_skip_relocation, ventura:       "2a2797d08f81b64f97fa82397bd646a970f039785a56ecd8ecd4dbbb3efd2e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88955c82416407f9b10331cacad6146b9e34e0c9d815a6fb591968fd90a34f54"
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
