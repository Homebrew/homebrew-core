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
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "e9af08238819333db3c5541bd2a01c0a08814de2b534ce9cab4f01ddc5dfc2f2"
    sha256 arm64_sequoia: "1e7bf8839ec4fa7a9c8e5b829f4b4fffa01ca6cd5b420ed4ae84d4526f8f195b"
    sha256 arm64_sonoma:  "a9426987655c6fdd7f4fcf9d6ce8e53f1113728a76ab525c8dbb23b4f6f0293d"
    sha256 sonoma:        "8ab528e9b2d23d0fcc7aa6849ad1a6f6f7a718db9868a2fd38e5963774cbf79e"
    sha256 arm64_linux:   "6cb7a68541d05fa5049b052b8df9e81de8c9834a330bb1605b92e32b556ae4cf"
    sha256 x86_64_linux:  "079a495c93e6d10cd4bdd71fe2797875e0fe33a98a2ccaccf17c4dcfd20e4e70"
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
