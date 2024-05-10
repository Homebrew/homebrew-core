class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.236.0.tar.gz"
  sha256 "4510c83f07285ebcbcbfef2aec002b234131b6bca147996f539384e5482fbbbb"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48c4c90b2061b99c06e4537b3910d5cf5842fbf7a70a5976ccb1f91e2649c1fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a37e75ecfc876866d830a1a30a4e4e13b8254f40547f943d834fabb86dfec037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd69d44f82b9cd54fdb34b9acc94521f52a37c92da158240893519fea044787"
    sha256 cellar: :any_skip_relocation, sonoma:         "fae98b2c865f12facd66ec7462487f8133c7a443210cad780528d73f8b994ae3"
    sha256 cellar: :any_skip_relocation, ventura:        "663b9b492b3da071b669e23f95da54adc0aea438834db2652a684f8d5ee31aaf"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a032b6cd466f2f7a4d8857aed35a89e0cffc9e207ea96d96dfab24f0f68005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f606ef2fc9c4a3444c7bacadfa16f945f4a4c208381188b0fad4c5c0c8a296"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
