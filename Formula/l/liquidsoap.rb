class Liquidsoap < Formula
  desc "Audio and video streaming language"
  homepage "https://www.liquidsoap.info"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/savonet/liquidsoap.git", branch: "main"

  stable do
    url "https://github.com/savonet/liquidsoap/archive/refs/tags/v2.4.5.tar.gz"
    sha256 "dc6dee2ef550dbae8f177ae6b0adb88cf789622ad0490176715606aee5b39622"

    # Remove bytes compat library reference (part of stdlib since OCaml 4.07)
    patch do
      url "https://github.com/savonet/liquidsoap/commit/2811ecc5848e02419c7d5c56fe7eb6d89af5b955.patch?full_index=1"
      sha256 "7dc9d38926c3ad35ec5d5b69a1ddae54e82cd1b264eb379228176896f0b48453"
      type :backport
      resolves "https://github.com/savonet/liquidsoap/pull/5239"
    end

    # Cap camomile below 2.1.0, which changed `Config.Type`
    patch do
      url "https://github.com/savonet/liquidsoap/commit/faf9bad3a0f8d94ea119092e94495e3e7b5cddce.patch?full_index=1"
      sha256 "f89e4ad6ea6a3c3f2b0c931236b4b7213258f695f79621594df80680e2c07dbb"
      type :cherry_pick
      resolves "https://github.com/savonet/liquidsoap/commit/faf9bad3a0f8d94ea119092e94495e3e7b5cddce"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "a82aa143b74fa434070e3bf00b479cc5ecd5cd1589ff61160956daeb799e5114"
    sha256 arm64_tahoe:       "d197a4de8dacf6e6fb801ea84f9914cd9c151a29f3337b197bdcd5381369fa69"
    sha256 arm64_sequoia:     "8e7d87772bf6c1ee613277bc6e090bc5256be73f1613790d45eef215bcbe4e15"
    sha256 arm64_linux:       "93cfb9b1361ef150afaa0177be5010272147a3a3e709076ce095cfaa2c8baae4"
    sha256 x86_64_linux:      "f7947b32cde2d5974bb3bec4653f9bcbea0efa06578ad9f3754b340fd21d3998"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  uses_from_macos "curl"

  def install
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
