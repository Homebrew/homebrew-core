class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.180.1.tar.gz"
  sha256 "b1335a19fdaa8e9bab021a56a6a7f51b20ff850ab5e7484ea6b47ca94a13c9d8"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d3260aa65e8cf3d971c13d57d388a2f6bb013d9687af54dfbf4a432e5de598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f0e824553cf0f9d66985b55b1f4e652b5d6f20292c1f87f07fe8aefe0842f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "53e718311594ace5bb7e17f92aa5060fbf79e8bf57cb42ccc32ab1f1eef89823"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfb0ef5ae33e5ee8ec483cced25a76fc58b0d95dea91829d57a160a1c3f52b20"
    sha256 cellar: :any_skip_relocation, catalina:       "4a61a8a6c6fce2cf7689f81e8981b5e76246138e97759de8573e080804412297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20004f2f2795ea595daa8e95c373d54429b629b44b1c4be4a460cf43f4ba9c1"
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
