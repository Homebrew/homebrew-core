class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.283.0.tar.gz"
  sha256 "b57a7f99b1d999344053c0f71b833a560090c17194dac0fdb0d88bc4265f814e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ab98c1fbe4de98ef381427d577585284a3d201113fe2fa968ef13b557aef0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0821f53d64617ba3f8dc61beb0d07ff9c14ebd9e85c9d6a990b3057fa7310f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7929ea00c31308fdea0e229deb6ee2dad10d039e8ce0e5a5ab63206655d2add7"
    sha256 cellar: :any_skip_relocation, sonoma:        "018543875574e775ab2b7b670c2a8b59e4ce813a22369a67a8cf271dec3fd130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41bc08e857dd3b9d9dbbb5e4859c61f6c898fa24bc00037b94406e87d44b9c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb53fab27f3736f1b0f66074744da3ac39990fca8d44669f787d01ca8fac9b53"
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
