class Liquidsoap < Formula
  desc "Audio and video streaming language"
  homepage "https://www.liquidsoap.info"
  license "GPL-2.0-or-later"
  head "https://github.com/savonet/liquidsoap.git", branch: "main"

  stable do
    url "https://github.com/savonet/liquidsoap/archive/refs/tags/v2.4.6.tar.gz"
    sha256 "a88da89382147d5d5923426e07b24b15197a5aaf8424ecf6fc58034d6c6839c2"

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
    sha256 arm64_golden_gate: "8da59f128f2acbd15f8ef3fc35bb428d9b7f768872076b8be9e628c4e8f3d77c"
    sha256 arm64_tahoe:       "c70998fb9ff3c2b969f60965d041dfd6fd89501b7be979ad4df5940756409323"
    sha256 arm64_sequoia:     "117f18b6eade5c588742d639188758c6863bd4cf8f5b8def453c71c0af48474a"
    sha256 arm64_linux:       "3e10060cb61360ec71c5670d67cecbf0fb60681a8a555dd5e3b1744f133b6c5d"
    sha256 x86_64_linux:      "40c92d79c6bb594efd4aafcab60d552156364655f287b2429eedfc741ba242be"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  uses_from_macos "curl"

  allow_network_access! :build

  def install
    # opam install prompts "Proceed? [Y/n]"; Homebrew's build has no tty to
    # answer it, so without this the build hangs forever.
    ENV["OPAMYES"] = "1"

    # Build as a release, not a dev snapshot.
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
    # TODO: Drop liquidsoap.opam's upper bound when the release includes
    # https://github.com/savonet/liquidsoap/pull/5166.
    system "opam", "install", "ffmpeg<1.4.0", "--no-depexts"

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
