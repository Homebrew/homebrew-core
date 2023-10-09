class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.218.0.tar.gz"
  sha256 "c657e58b017bab9377bc2b3fad2da0e065de5e445df15280e006abe58057deea"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddeb70afe5ad00f42e2f969e28ed14d417b84cf0337c63dfe8cb561eccd4c153"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e36d6c5682a36fe21414f77e53528f57cf9059974ff2a5fc2dd10a49cd0d0bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9b1982873d7c275b04663e97118877b25b91d2ade25c80ba3324472c225c3ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "41e8686a57b29db08b9ada150fb17fc57a79c23aba545d21f0fc26fc3209d7ec"
    sha256 cellar: :any_skip_relocation, ventura:        "70d470059e975e71c9518e9f08faded0be2817aa82333de67abe05011d8a4fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "98eafa7fdc74f74b27519079f9c188acf7b6078bcf3c07984a6b71a38f6b5828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63073607990a1f60f79a8603391fd81f0be0119774fcf0f169891237f88568a6"
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
