class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.8.tar.gz"
  sha256 "662c910f774e9fee3a19c4e057f380581ab2fc4ee52da4761304ac9c31b8869d"
  license "MIT"
  revision 2

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "78208d12d896d767f2cf86d461a3d7c7c89d4bcd300000958a64bd5a91008003"
    sha256               arm64_sequoia: "d6a7d8f506f4d089a8f30572798cb972357c01eac1a487f14c3aafeecf1fe980"
    sha256               arm64_sonoma:  "ca98c985d8842a3f5062b7d48592b6f0347a8f5459b23907253d15e0b3abfd29"
    sha256               arm64_ventura: "8b74e02480dff2c49430ee62defa16c3f9dcd87f174b98e6e8e648dcbc8bd8ef"
    sha256 cellar: :any, sonoma:        "40788547ebec28eaed2a8811f9b3bd748a069abe43cca7c9485705d1b82681d1"
    sha256 cellar: :any, ventura:       "b48edfe29118e8d0a15ac967c3dd8b8aa4de92c6e7b70190658a08e3a7e58398"
    sha256               arm64_linux:   "37808e687a6c05f3ffcc60ebbcc85c816e2daea1b7298f6cde2a1b67718cfc1b"
    sha256               x86_64_linux:  "2f34394dd75304d28a920c3f20abb41d206af10ba07b010fa3d702ea09293537"
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
