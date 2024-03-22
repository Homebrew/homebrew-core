class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.6.tar.gz"
  sha256 "2df996279ae16b606db5ff5879f93dbfade0898db9f1a3e82f7f845faa2930a2"
  license "MIT"
  revision 1

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "57ff114e13929f3b5382c78418a43b896cd2c4f3d9627d9017b1d94a2609489a"
    sha256 arm64_ventura:  "377870c6a2a9a7e059136d3fb161e9cf0d48191f4e3df7fb7adfc7003e0527fc"
    sha256 arm64_monterey: "ad81c990d61dbcee8f0ab536ac519f697e7839313290a3b3f9ccff2717100a07"
    sha256 sonoma:         "187c3979f7d1a04e3e009a9c36d0943c5d6bf7ae780fdfb38a27e0923d31eea6"
    sha256 ventura:        "a0fc2d66f141c96efbf271429b7655ca53f05ee1c33350822903807beb8a96d7"
    sha256 monterey:       "32251158ac86cbfafb14df0866da222e540fa0c4a30a023e631fb411dc604a8d"
    sha256 x86_64_linux:   "0d81ac15dc0af7b4675ca0c2a5f302594ed5f5a676af51066d7d9c0f8f41faf5"
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

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
