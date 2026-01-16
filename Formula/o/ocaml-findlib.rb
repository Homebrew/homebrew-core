class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "https://github.com/ocaml/ocamlfind/archive/refs/tags/findlib-1.9.8.tar.gz"
  sha256 "d6899935ccabf67f067a9af3f3f88d94e310075d13c648fa03ff498769ce039d"
  license "MIT"
  revision 2

  livecheck do
    url "https://opam.ocaml.org/packages/ocamlfind/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "6f6f7669b4187e082f14cb9c9f617bec4490a32d719caecad5b7f4d01dff2d91"
    sha256               arm64_sequoia: "fca7c5a0a0cf78d4339970cee1d0a80605e4adce120ba9e75eaaaed96cd0055d"
    sha256               arm64_sonoma:  "4cf42f610e5248913f7cf5b494ccb84384063c3a13470547fc573dc1a532e746"
    sha256 cellar: :any, sonoma:        "4addf3b776fbe1b639f4c3f7412a04ba799125dbdc567b79879310401481bd54"
    sha256               arm64_linux:   "06f20185aef240f8b740a0347c04e4ba2f912c912b8c36b3464cc54fafaa1f56"
    sha256               x86_64_linux:  "26996e1d983d47ca18e8fef158d9254b94a2ea7e0399386f518e9935aaf032c4"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX/"lib/ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}/ocaml",
                              "OCAML_CORE_STDLIB=#{lib}/ocaml"

    # Avoid conflict with ocaml-num package
    rm_r(Dir[lib/"ocaml/num", lib/"ocaml/num-top"])

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
