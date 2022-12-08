class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.195.0.tar.gz"
  sha256 "c5ec1d12318c55a50cdd0b05643222107286acc01ca05dd9b00d2e177b5f27ed"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "257c28f3188e8554b7e166082fd92fa472a51f0b04e87f14bc87fb81fa83e1fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e294ba2b4e29002026f7ed23d524478c7b1bc37bd74c17f66c4437af58c34db9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd6c63771ffb66b18bd4e7eea510407fc13d6f57d180a128e68240062a043de"
    sha256 cellar: :any_skip_relocation, ventura:        "27bcb52b01da41612c23dacb7bae43c7165b8561547c15a7d774e08ef99ed398"
    sha256 cellar: :any_skip_relocation, monterey:       "24be6e538acede90d53e56068cbd2f2c7f5c8f997a8ed98aeb2c02a103c98992"
    sha256 cellar: :any_skip_relocation, big_sur:        "40bb9f0901be969b09476bb53364796159049136a39e269cc4356d2c448c9718"
    sha256 cellar: :any_skip_relocation, catalina:       "62054496ba10ccead4e87a7d9f1ad49000e52b6f46134a696b51b1d7f4f482ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8d471018e5132ccef5cb072bb128b1fe980e8d28ebc9eb778a8d421a6e7654"
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
