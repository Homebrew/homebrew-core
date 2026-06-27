class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.24.0/dune-3.24.0.tbz"
  sha256 "501f73727a939aa954dc0537e37792a1ba189e61719c81dc367e2594fe016034"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eb7cee4707e9de9ce9e487b2da3b45be180a74f4ff78c163b4799c24b34d439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d2e226a457ed997abe931eaee336702f8fb38101be6a269e57ad2ce135a0f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ebbe6b74c818e498c991c71ab67f3bafaf588c85f8e2fcd9398ba483f38b88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "369724727a590f2889546318c242b59443388e378cd1ee8c4575dda955fc0396"
    sha256 cellar: :any,                 arm64_linux:   "b920e62fafb93d9e20e8fbd21fc5dc2749961a892bfdbec6ba6dabf513db0185"
    sha256 cellar: :any,                 x86_64_linux:  "a7c7bd02bf5f12acfec76a592bb48e48911155a69b6291726f3ec29039abd308"
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
