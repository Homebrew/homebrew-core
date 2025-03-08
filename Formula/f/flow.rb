class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.263.0.tar.gz"
  sha256 "6217ce64cd04522d7f21d2a7450de8908ee54deb10dd351ab467267aea3e0c05"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de7b22860157baa974c3a646e9e74009559be7127cb0700965a691763652fa56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ac1fc07a1d7946c9b043d87d51d9a8635b6a32dc54534cc6c3990e4d472d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d89c72b06fb0b89664a19a177f5878e71306eed056d7fe065ac645c7ff102915"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbaffb2f0ac8156c9eb919001d800993c8072ed0913fb4b42389ac5fd6060cfb"
    sha256 cellar: :any_skip_relocation, ventura:       "24440d454ab6ec5516b04e755f912c06fa253f48d31769bcc8ff4f9b2ff6db73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146097ccd9dfd73a55e3ffd378dc2e49290db624a1ebb66f974b7aaa214348c5"
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
