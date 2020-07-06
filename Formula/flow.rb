class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.128.0.tar.gz"
  sha256 "91a6c83840ce7daa36d1c67272c5526b7118ce24ae106a4fb93e692f0f58f530"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "868560f0b7a49b5147c8d6a18f5f2e38bcf84ccc6a62ef98b6687b4dbbe17f22" => :catalina
    sha256 "c17d69ef32637f3d7bf872f436c6696562137a98f6f81070b8fb2eb04a1e5a5d" => :mojave
    sha256 "516210a13a585f01357021c41fa02efb54df60d21a5b600ef5d764bc51fb8ac7" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

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
