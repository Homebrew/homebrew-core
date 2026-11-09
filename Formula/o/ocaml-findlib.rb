class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "https://github.com/ocaml/ocamlfind/archive/refs/tags/findlib-1.9.8.tar.gz"
  sha256 "d6899935ccabf67f067a9af3f3f88d94e310075d13c648fa03ff498769ce039d"
  license "MIT"
  revision 6
  compatibility_version 1

  livecheck do
    url "https://opam.ocaml.org/packages/ocamlfind/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e3095dec7164f19e001e68f0fcde7706ebdf0c948f62b49567b01d43a68f2c6a"
    sha256 arm64_tahoe:       "c8059ed5d4c4be71c00cbc45523f849a5b20978fd26d169ca1a0d026b833254f"
    sha256 arm64_sequoia:     "7d798db740a8f7e6a05f6b692efc4683ddbe29ca3604271eeb736e134006b7c6"
    sha256 arm64_linux:       "af16f13fa51e2174469910fd63fad1e3af2b7e9c66168d65f2c75870c9244ca6"
    sha256 x86_64_linux:      "8a2ed48080cb0894ee302826faf1d7c57d2f0fc0ded2599f82f68e2f4cd7d036"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  deny_network_access!

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

    # Check if we need to rebuild ocaml-findlib to be used as a library
    (testpath/"test.ml").write <<~OCAML
      open Findlib;;
      Findlib.init();
    OCAML
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml/findlib", "-o", "test", "findlib.cmxa", "test.ml"
    system "./test"
  end
end
