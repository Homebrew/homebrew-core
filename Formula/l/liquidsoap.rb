class Liquidsoap < Formula
  desc "Audio and video streaming language"
  homepage "https://www.liquidsoap.info"
  url "https://github.com/savonet/liquidsoap/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "dc6dee2ef550dbae8f177ae6b0adb88cf789622ad0490176715606aee5b39622"
  license "GPL-2.0-or-later"
  head "https://github.com/savonet/liquidsoap.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "def47e551b5299a3373d24ae533d298e95ce5e2899d8fceeef33276dd4bc39ef"
    sha256 arm64_sequoia: "421599d8288d01074fcbc45812eba59d941198d17d45bb9cbdced36c57c28b6e"
    sha256 arm64_sonoma:  "f61168689134eaf8a249cdd183151cd764a3bc71ac134ac493d3ac7646197e5b"
    sha256 sonoma:        "503abc5ddff29224f39ea29d2c7657e6d94cb63ab2edd2b4898334ac74a43a00"
    sha256 arm64_linux:   "5976e78257131e2112fd23ff896b9065df84ecb72ac944ce58c3af1308155f3c"
    sha256 x86_64_linux:  "a43a166718cb5d26ca33cd8f2cf968f6050be5596568ada4616f74cd0d6f9378"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  uses_from_macos "curl"

  def install
    # Remove bytes compat library reference (part of stdlib since OCaml 4.07).
    # Fixed upstream in https://github.com/savonet/liquidsoap/pull/5239;
    # remove this inreplace once that PR is merged and released.
    inreplace "src/modules/cry/dune",
              "(libraries bytes unix stdlib_utils)",
              "(libraries unix stdlib_utils)"

    # opam install prompts "Proceed? [Y/n]"; Homebrew's build has no tty to
    # answer it, so without this the build hangs forever.
    ENV["OPAMYES"] = "1"

    # Build as a release, not a dev snapshot: reports "2.4.5" not "2.4.5+dev".
    ENV["IS_SNAPSHOT"] = "false"

    # opam defaults its root to $HOME/.opam; pin it into the build tree so the
    # camomile copy step below can locate the switch.
    ENV["OPAMROOT"] = buildpath/".opam"

    # liquidsoap bakes the location of its runtime files into the binary. The
    # default target uses system paths (e.g. /usr/share) that don't exist in a
    # Homebrew install; the posix target lets us point them inside the keg.
    #   LIBS_DIR     - the stdlib; if wrong, liquidsoap can't start (no stdlib.liq)
    #   CAMOMILE_DIR - the Unicode data; if wrong, it's missing from the install
    # The test block checks both stay correct.
    ENV["LIQUIDSOAP_BUILD_TARGET"] = "posix"
    ENV["LIQUIDSOAP_LIBS_DIR"] = pkgshare/"libs"
    ENV["LIQUIDSOAP_CAMOMILE_DIR"] = pkgshare/"camomile"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"

    system "opam", "install", "--deps-only", "--no-depexts",
           "./opam/liquidsoap.opam", "./opam/liquidsoap-lang.opam"

    # OCaml ffmpeg bindings; the depends_on "ffmpeg" provides the C libraries.
    system "opam", "install", "ffmpeg", "--no-depexts"

    system "opam", "exec", "--", "dune", "build", "-p", "liquidsoap,liquidsoap-lang"
    system "opam", "exec", "--", "dune", "install", "-p", "liquidsoap,liquidsoap-lang",
           "--prefix", prefix

    man1.install Dir[prefix/"man/man1/*"]
    rm_r(prefix/"man")

    # Move stdlib libs to where the binary expects them (share/liquidsoap/)
    (pkgshare/"libs").install Dir[share/"liquidsoap-lang/libs/*"]
    rm_r(share/"liquidsoap-lang")

    # Copy camomile unicode data from opam switch
    camomile_share = Pathname.glob(buildpath/".opam/ocaml-system/share/camomile").first
    (pkgshare/"camomile").install Dir[camomile_share/"*"] if camomile_share&.exist?
  end

  test do
    # stdlib loads and the audio pipeline runs (exercises the posix target and
    # the relocated stdlib at LIQUIDSOAP_LIBS_DIR).
    output = shell_output("#{bin}/liquidsoap 'thread.run(delay=2., shutdown) " \
                          "output.file(%wav, fallible=true, " \
                          "\"#{testpath}/sine.wav\", sine(duration=1.))' 2>&1")
    assert_path_exists testpath/"sine.wav"
    assert_match "audio=pcm(stereo)", output

    # Release build, not a "+dev" snapshot (IS_SNAPSHOT=false).
    assert_equal "Liquidsoap #{version}",
                 shell_output("#{bin}/liquidsoap --version").lines.first.strip

    # The posix target must bake the stdlib and Unicode-data paths inside the
    # prefix, not FHS defaults like /usr/share (guards LIBS_DIR and CAMOMILE_DIR).
    config = shell_output("#{bin}/liquidsoap --build-config")
    assert_match "#{pkgshare}/libs", config
    assert_match "#{pkgshare}/camomile", config
  end
end
