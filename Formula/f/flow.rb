class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.314.0.tar.gz"
  sha256 "24f9f212fb8a5b712e7e433c22f91b06d17795faa60f9c5185b2b5e890b04d11"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1d589bd5f12a6f6a15fc3521a44aa4e21b6792326bb2f3f6dc25194bc70fb6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57db72e09e374ca5e8315ea05fd901150e606217423b617c0130012dfc8c22b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aef762febffff1824302aec5a392454762c0e4086b1113115645326aec687e7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1653b2af03af422e89f3c2004f575ee42423b13de0f4f7e35359f762c5dbcf16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2656f6936c514ed93f65590b25111502d2b506d84b1ab53e3f3119922e60b179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f002e8c7113a93af2a4ce69efafed447488f86ced553a984291aeb0f179f3b"
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
