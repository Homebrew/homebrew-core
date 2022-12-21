class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.6.2/dune-3.6.2.tbz"
  sha256 "b6d4ab848efb04aa2a325d0015d32ed4414ed7130ec7aa12f98158eff445cf3c"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3b09ec67756894cf1ad0ecc7a280324b5f694e1993eda3fed20c554c16ac558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22356cee578225e906d0982b0c04a38bf395c4f5249ac5c0e94a3fb54bd938c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea8092effe61342886b35d1de52d4e18d4d21ab4bc39328b6da4d75d1081a916"
    sha256 cellar: :any_skip_relocation, ventura:        "84e5412fbff87b7fd0968b80035dfc903f09f771564a2e62b8b1fbe97d703bdd"
    sha256 cellar: :any_skip_relocation, monterey:       "26e36453b741b5c6f5f307cfeb3b8047e4d6afd75a2d5137264896b596257163"
    sha256 cellar: :any_skip_relocation, big_sur:        "c496303691c6dc59a2e335195bb85e13317c06ef3d847ba29763318eb994ef3f"
    sha256 cellar: :any_skip_relocation, catalina:       "27cebca2a88cc76390958a7f55dacb65543b451037312045eed5991f572e3780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aec348495d251736d17ae2cf030cd095b529629e6123c88f713dfaf1f1d8205"
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
