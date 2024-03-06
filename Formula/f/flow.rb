class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.230.0.tar.gz"
  sha256 "729b881d9bf7a9c9b6f86855b019e6764c68eb273caaa7b595869ec569145f07"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be0ddceb66548d2a384a9e82e6b897cae509de58d705e9ac4f83865facc5ce06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "907e1efacf0b33511b8fa4313bd6198d5af11696ae4dab542c0940502ccc3f66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9b7633210d280fe5846c9d787fc7b31a9d5ef4f5ff5d66e0a87b2ec76c83c14"
    sha256 cellar: :any_skip_relocation, sonoma:         "abaae4a2f451ac7cf61873795f3129e8e10528889a467ac84c8fa0f9cff7820c"
    sha256 cellar: :any_skip_relocation, ventura:        "c69c41ff6a8d8e948b33f76a1dc1c47bf50a472386d79a8a5430e8caad98c4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "ba007b1ac70972c2ce52178d7f067ce6e5f043d50ff6796ab013a2d9f330d48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e295b4769486c00d7742da9b4b4b83a2657233f6193d113396166a736fc8c6"
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
