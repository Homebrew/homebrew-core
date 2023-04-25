class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.7.1/dune-3.7.1.tbz"
  sha256 "adfc38f14c0188a2ad80d61451d011d27ab8839b717492d7ad42f7cb911c54c3"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5946e574f19d9cd0c1a634418663b0de382f97f9f46aa4d506090cb16d3192bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7939d1bfa1bcbe2d4536423d50297ab1012d890ec4fc0a55b4ce12840d75453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a85dc79487cedaa1588774824b179c199f7556c9c2ade63627d04dce17139726"
    sha256 cellar: :any_skip_relocation, ventura:        "64c1b85875cf8023f02438ca3a08efadd89d281fc6f7770956d75b11ee09f5ce"
    sha256 cellar: :any_skip_relocation, monterey:       "79228181e6dd0a03aa113fd67f8babe5e17cbbea2eca3a911c0310cb5be3926e"
    sha256 cellar: :any_skip_relocation, big_sur:        "00318d55e1666c87833d0ee4c0ee4e3f5aa3fbffbd9ce2eb6f8bb847562e3937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9c553793096e131b701d324cc5098ceeee4e37fb5b2f438e354b28d1776264"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
