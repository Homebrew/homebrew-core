class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.23.0/dune-3.23.0.tbz"
  sha256 "e92987ffe4bc7956b18b2251b0f9844d55dfa387035ce60a3f0fd5ac4e2617d4"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2a8048e2373e8fe95b2f8874cbf79e4408b32e013118b0ba33bf0cdd49c4cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e9801a6663f2134d56231295f99c8044ddb00b9402c0e4dd064c8066c47086f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78fd8612901c5f52e4d28267643d4950fbf48fc8ba9788fde573cd9c7f44c62a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdfb7965923eaf2d331972eaa54bc974ac7bbce7f38370b5a562ed2dff4a8369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31265a4ed98574050a849b95589fd1382a5fe3cd4e4cabe2560c3787a5edc31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad3704a9e5d2fa4c11d71a38b1cb7537caade82910a952a1b38151886b64918"
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
