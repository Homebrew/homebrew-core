class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  head "https://github.com/facebook/flow.git"

  stable do
    url "https://github.com/facebook/flow/archive/v0.48.0.tar.gz"
    sha256 "8772896075dc4028e62720fe18a6608f278f471931b2a8fff280d0efc0fd4f29"

    # Remove for > 0.48.0
    # Fix "Error: Some fatal warnings were triggered"
    # Upstream commit from 13 Jun 2017 "[PR] Disable all warnings for homebrew &
    # opam release builds"
    patch do
      url "https://github.com/facebook/flow/commit/9130d821d.patch"
      sha256 "acbe71d6f065390f86184827ada544840c9fdfa654bd0c81446b6fd5173002f4"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d05f27bdcc36e5f142bda40560a98c3f7f5acaa10fe301904b632651d962e453" => :sierra
    sha256 "e71d050e7205ac330bb4d09e13e5bbf3e53127d83bedbacbfde5424fe5da31bf" => :el_capitan
    sha256 "6655d84fc3987f59b2827c9ff43383a6153b485c286e76db14c17ce50eaa5dad" => :yosemite
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
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
