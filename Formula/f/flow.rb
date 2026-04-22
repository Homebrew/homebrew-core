class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.310.0.tar.gz"
  sha256 "a54fa6f0e66cb64ffad0fdf3cd2131d895b1391931c4bda8c189cb7ac03820c1"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6406333fb8e713fbde8a688cbd54d7d5f773200b3364ecda77d4cff527922e35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723d44584dbb669ce7a88a2f2a186644abd7a4f8c8f8a411e895e1f0f0c05122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb684b5596304b3604debc62ebb7f5a602472339bbdd1013e52f8ac68b42aaab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7719bfea0045da94b7840d6ad72fc2aefe1a17c427ea25e22ba562b30d8f0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28bffa1900d8e0ac73363c9148b924eb321a9f584dfaa9cfa1fd8157ff691b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c765d85cbb4863b70fd6f1659e041bc5098bb301b321f076737c0ee26fe9659"
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
