class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.179.0.tar.gz"
  sha256 "5b35ec6a051ffc399616b0b3e002a320457efd1b420530b672c137d07bbe3501"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e51ff19ef41550b7c1bd610c706b98e4cfd35b8b89a91500b6316af7101c89c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29f5f60fe5e975989c5ad4257428f4a5fb0846fe1b7c5c4e8a143a22ed44558"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc70ee9513e2371e84b9f084af1703fb3eadde177edcab040aaa180585dd2a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "303ec1e0beaf7158d6fa0636f6ccf13b6f14362a43083ec228b58feac9927458"
    sha256 cellar: :any_skip_relocation, catalina:       "394562565342d07997ef39c669ce9da62070a214059bdaa4edde10dad966da16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29b0d279a1e82ebbc9cfcac71273db8a1e5185b2c08ba655077be73ad46a0bd"
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
