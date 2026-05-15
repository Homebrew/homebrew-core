# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp5
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-5.4/ocaml-5.4.1.tar.xz"
  sha256 "b1e297adc186635540758eb064c7fab025598ae4436f3b9767e5025188b4e0ab"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  compatibility_version 2
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256               arm64_tahoe:   "67867c7587d4add83c1983325c2ffb7107760637fe817fd98bdbbc8ed374d00e"
    sha256               arm64_sequoia: "8d8d03eebe087c0740b36890ec4d2446004a2f1ad848a5ee5f63bb0a79995aa5"
    sha256               arm64_sonoma:  "a407be2f74a548097b732f4eeaf50a84bc73436b962eb27cb5e5b8d5e8fc33e9"
    sha256 cellar: :any, sonoma:        "1dc2f870b89858601afc035baecb02c2aeaf3bcde60f7bf0e7c476812c28a998"
    sha256               arm64_linux:   "9af91f4fb0c768a44e7747877f5b83c01cf24b323a40cfb9e1ec1e241a269079"
    sha256               x86_64_linux:  "da0f6cc0e1b0cc66bfefc29d116b3fbffe482953574b8295764de313d40d1ae3"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --enable-debug-runtime
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/ocaml 2>&1", "let x = 1 ;;")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
