class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.1.tar.gz"
  sha256 "2b42b8bd54488d64c4bf3cb7054b4b37bd30c1dc12bd431ea1e4d7ad8a980fe2"
  license "MIT"
  revision 1

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b05f66339e91c8aa5d0dc67242a82dc8c39a254532d8017c5d35bfd31139039e"
    sha256 arm64_big_sur:  "747fcd3b425c998c45b5f83aaa72bab0a06a584ee409284447824472058a737e"
    sha256 monterey:       "f5e661018713080fa77ad4d33f1890f51682971eb9593d821340e51655797be8"
    sha256 big_sur:        "908202a20c99ce1e3021a2f415d876f59d8d65912df486d4085ca01b93b17e7a"
    sha256 catalina:       "64e0d27b20e1b6ea55beda463d21701bb96688bd9dbda5b5e66095eddd25ef49"
    sha256 mojave:         "e236f3f0d85b74fc8ced41f56cf5caae52d6ef5f542b26dc27563a1db1ecbccf"
    sha256 x86_64_linux:   "fc83a61ef983085665a7a144d0d1d44d014da88cbb7a18b072a486555e460a40"
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
    rm_rf Dir[lib/"ocaml/num", lib/"ocaml/num-top"]
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
