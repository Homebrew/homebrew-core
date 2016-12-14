# flow: Build a bottle for Linuxbrew
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.37.0.tar.gz"
  sha256 "82e1ec628f9c65ae48fab8b7a762c537a462c8978eb9a2e4059f207d56f6a89f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5aeb06918e6723887160f2cde50089ea73869eb39096b8b740443f5cc2831b97" => :sierra
    sha256 "8a48f7d56bd0e6517beee5122439be3d7f41e7cc2fb8fff36fe7aacca806361e" => :el_capitan
    sha256 "8ff142781e442f563232742e87ecc76aac01137595c368e2c39135b5705fd448" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "elfutils" unless OS.mac?

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
