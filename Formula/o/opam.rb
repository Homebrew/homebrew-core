class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.3.0/opam-full-2.3.0.tar.gz"
  sha256 "506ba76865dc315b67df9aa89e7abd5c1a897a7f0a92d7b2694974fdc532b346"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/ocaml/opam.git", branch: "master"

  # Upstream sometimes publishes tarballs with a version suffix (e.g. 2.2.0-2)
  # to an existing tag (e.g. 2.2.0), so we match versions from release assets.
  livecheck do
    url :stable
    regex(/^opam-full[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47acff18f55443e9c33b6c39cbd9a20e884f98adcb2919d29854c5d0e4cd089d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62cde967f16957eb5ed95c3c4519b91bd36feef87b382fec69e68ec8d4bf0f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eea0a5362042e93f2532e0d263a00dd8c2025ec894203255af4791a247fee125"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58068cb65843ce811808ddc622bb5333cd1b13eef483f0c4420bf2e904013e2"
    sha256 cellar: :any_skip_relocation, ventura:       "98346e4e16d18be444cbbd432798a5dd1e9664c3519af0f070f0aa2cb230b283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b89e24fa3d72680f6640b9e3faf38ee1e92a8681ffab4d686d125636fc3b1acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a94893ed75763ac3ef12792c4873ed120f9165f30b20bb27a24a1d01a395f5"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  # Fix compilation on macOS with ocaml >= 5.3. Remove in the next release.
  # Ref https://github.com/ocaml/opam/pull/6192
  patch :DATA

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-vendored-deps", "--with-mccs"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh" => "opam"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
      OPAM uses ~/.opam by default for its package database, so you need to
      initialize it first by running:

      $ opam init
    EOS
  end

  test do
    system bin/"opam", "init", "--auto-setup", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end

__END__
diff --git a/src_ext/Makefile.sources b/src_ext/Makefile.sources
index 4a82329168ce496697d42845a048a9ae5e4b50a7..01edf1a2989a87019dad20a9880d43a6b37cc38d 100644
--- a/src_ext/Makefile.sources
+++ b/src_ext/Makefile.sources
@@ -22,8 +22,8 @@ MD5_cudf = ed8fea314d0c6dc0d8811ccf860c53dd
 URL_dose3 = https://gitlab.com/irill/dose3/-/archive/7.0.0/dose3-7.0.0.tar.gz
 MD5_dose3 = bc99cbcea8fca29dca3ebbee54be45e1

-URL_mccs = https://github.com/ocaml-opam/ocaml-mccs/releases/download/1.1+18/mccs-1.1+18.tar.gz
-MD5_mccs = 3fd6f609a02f3357f57570750fcacde0
+URL_mccs = https://github.com/ocaml-opam/ocaml-mccs/releases/download/1.1+19/mccs-1.1+19.tar.gz
+MD5_mccs = f852da188bf7de20e64be2fce0e48e0a

 URL_opam-0install-cudf = https://github.com/ocaml-opam/opam-0install-cudf/releases/download/v0.5.0/opam-0install-cudf-0.5.0.tar.gz
 MD5_opam-0install-cudf = 75419722aa839f518a25cae1b3c6efd4
