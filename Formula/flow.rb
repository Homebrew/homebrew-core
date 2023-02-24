class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.200.1.tar.gz"
  sha256 "493d97b8afd9f1bad0012e1bfcee9366cc8a041b82e75d53ba64d588bb14f4ac"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87a38591c9c1319cbfa7190db8048783057ad1e973481615a84f38e202fccd23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b31f3440d6e2a7a753be3ddf28037488933013bf4b0e9c521b2209086b1c3762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9127863c04c13c8002f78ecef09fb4852fba69b345bba946449057729381058"
    sha256 cellar: :any_skip_relocation, ventura:        "7ac71663436ae78f5ee7091616451beee56c8a565568337ce3d96d3ec0d2b68c"
    sha256 cellar: :any_skip_relocation, monterey:       "81630c8a5872f0aeda6576fd9683c48c8eeb34c9c38f7aa0344ab69399a0664b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e93d4fa1bb76f13755b294f71272dcabedc1f3f2a1e054419d436b4d47444126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e009a6ad671fa45b049803a2e88b2bd94b1ab7766a6397f3455f8fb5dc4c4077"
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
