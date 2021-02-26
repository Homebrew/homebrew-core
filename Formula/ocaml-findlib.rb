class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.8.1.tar.gz"
  sha256 "8e85cfa57e8745715432df3116697c8f41cb24b5ec16d1d5acd25e0196d34303"
  license "MIT"
  revision 4

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d8b36f14f73e5d2122029e86b3d2e057097fba83d52771e7203f315b84a0ad37"
    sha256 big_sur:       "d0049172eb8e73000a7f085348dc8c2d89c891a67ade6a46b61acd7c9a330da8"
    sha256 catalina:      "ba498040816b2b5b00ed84a96107119a99a52a0815b86ace5e5708f807be1ddb"
    sha256 mojave:        "b9af770177876ae3ffff6cca808a7ea72866a0bfe3b92a987878629fc42b3eff"
    sha256 high_sierra:   "a412ed75fa6bd7180846f2305eea5d2a4170bb41535c26fb047fbbd2b0adef8a"
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
