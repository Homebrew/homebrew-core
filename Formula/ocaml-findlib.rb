class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.1.tar.gz"
  sha256 "2b42b8bd54488d64c4bf3cb7054b4b37bd30c1dc12bd431ea1e4d7ad8a980fe2"
  license "MIT"

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "fb8afb323b73f80191e60a1a69c7c32d8554f14001ae073e92c22bddcdd35e8c"
    sha256 big_sur:       "851a6f7768fa92d1a35581de5643269eb741d301a7bd545bd5693e75716334cc"
    sha256 catalina:      "826fcf4cff66d5ec949584047026f97dd2fab88cd717038ab4e37ef64953ed00"
    sha256 mojave:        "ba78187caa699f566aa2b791bb7345224fd7ba60c467764aa809ede357983ade"
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
