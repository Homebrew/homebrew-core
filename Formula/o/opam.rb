class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.4.0/opam-full-2.4.0.tar.gz"
  sha256 "119f41efb1192dad35f447fbf1c6202ffc331105e949d2980a75df8cb2c93282"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1168249459a563cf8fb7bc00128a8f1a94a477139d3daad42e2470b62866145c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40758a0db823e22ccf3f121f0203af64903c243d7362217c08d365a30f37bb99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b272340572473457cbb347bf3a2b5c32f2848094a6c2c0c5f2269a9614ddb92"
    sha256 cellar: :any_skip_relocation, sonoma:        "abbbc044f296e5e3922e0be58688c865cf59eb12bbd52aed0e8aeb696804f97c"
    sha256 cellar: :any_skip_relocation, ventura:       "48b8b417a23fe28cfadee7ae10318ad20fb2bb131aad65a28499153a24f8c1eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9e6fb066364dfbcee7022cbda6ef4a1cb68959b71a254e4d649503839adcfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d8bf724933590873417eecc9e144633b1a907f1ad18d5df281d3c2012c0935"
  end

  depends_on "ocaml" => [:build, :test]

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
