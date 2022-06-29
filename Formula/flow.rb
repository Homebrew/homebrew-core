class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.181.2.tar.gz"
  sha256 "901f0cfbcea6f59c011ea52dd3f3736a738753bf391235f59bd152794e8248d5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94888e55cddd186f8b6259ded87cbb9ad32c6163526403e36fd8bd2f68194ebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1cbfa2d48ba9e525fcdc9f79bcc8c0068e7edb7519e6c4e2188715ce06fc0c8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8884a30f65a9bda1d915637295846bad76a30a553e59bebd4e7731cf35dccf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed7073108a95ce770365a895155cfe08f9ceb07d05c5494e0b98b0b757cc30dd"
    sha256 cellar: :any_skip_relocation, catalina:       "118a9999adb46167d438f97d6e545497d8d6fc5f02498ffaa1facaf37f85ca61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe6eec64826b7a819b5255afb4bbbde36db81d5b35ec3176a1a6bf342a81964"
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
