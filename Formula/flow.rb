class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.37.0.tar.gz"
  sha256 "82e1ec628f9c65ae48fab8b7a762c537a462c8978eb9a2e4059f207d56f6a89f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7e9a3011c05ceb26b20c590746441816ac9697453c98d7ff40157da42ef31ec" => :sierra
    sha256 "09b1cd562b32b5e4776ce063bac3053c02afabffcb3dc9f4270d266cd28850a7" => :el_capitan
    sha256 "96ab80b672aa81a15e6ff736e5bfae4db30923c72a5acb17c76ba18c8dbf48eb" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build

  def install
    system "make"
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
