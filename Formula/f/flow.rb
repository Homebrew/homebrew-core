class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.305.1.tar.gz"
  sha256 "ce05aecb25037f4e27e40e10c6fc9c63a29813002a4faf692f498e008f4ba452"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca33debd1aaddccb42f3c6bf61d31aa567ad4ba7763aaf507d416e3165c36818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67b2fccab5aa0c7cb0c6a943a78184e711d501679a48fcbbb63b8d22790e9bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3b7f8550ad4d08a2ea2fd200238df131ff27b0a38f5eca7b2030cc1b1c7f8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec1948966cadd7664bc6b3a0248bd1c1b719127c304f81dcc09114c157b90a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e712b2f6cbcc5276aceed7134395d56207a8067a03c86bed2a614f31510c29a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ddf059bc5c08b5850c5ecf94445aeada955dedb488437190ac2c07042a3d33"
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
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
