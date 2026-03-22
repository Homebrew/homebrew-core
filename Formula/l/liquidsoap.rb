class Liquidsoap < Formula
  desc "Audio and video streaming language"
  homepage "https://www.liquidsoap.info"
  url "https://github.com/savonet/liquidsoap/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "1bd24eea43284fd36e8018c4e0ff15fc970233b23dd882238d077c042a72cfd2"
  license "GPL-2.0-or-later"
  head "https://github.com/savonet/liquidsoap.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  uses_from_macos "curl"

  def install
    # Patch posix paths to use Homebrew prefix
    inreplace "src/core/base/liquidsoap_paths.posix.ml" do |s|
      s.gsub! '"/var/run/liquidsoap"', "\"#{var}/run/liquidsoap\""
      s.gsub! '"/var/log/liquidsoap"', "\"#{var}/log/liquidsoap\""
      s.gsub! '"/usr/share/liquidsoap/libs"', "\"#{pkgshare}/libs\""
      s.gsub! '"/usr/share/liquidsoap/bin"', "\"#{pkgshare}/bin\""
      s.gsub! '"/usr/share/liquidsoap/camomile"', "\"#{pkgshare}/camomile\""
      s.gsub! 'Some "/var/cache/liquidsoap"', "Some \"#{var}/cache/liquidsoap\""
    end

    # Remove bytes compat library reference (part of stdlib since OCaml 4.07)
    inreplace "src/modules/cry/dune", "(libraries bytes unix)", "(libraries unix)"

    ENV["LIQUIDSOAP_BUILD_TARGET"] = "posix"
    ENV["IS_SNAPSHOT"] = "false"
    ENV.deparallelize

    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["OPAMNODEPEXTS"] = "1"
    ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}/lib"
    ENV["CPATH"] = "#{HOMEBREW_PREFIX}/include"
    ENV["OPAMSOLVERTIMEOUT"] = "1200"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"

    # Install required OCaml dependencies from local opam files
    system "opam", "install", "--deps-only", "--no-depexts",
           "./opam/liquidsoap.opam", "./opam/liquidsoap-lang.opam"

    # Install optional ffmpeg OCaml bindings for multimedia support
    system "opam", "install", "ffmpeg", "--no-depexts"

    # Build and install
    system "opam", "exec", "--", "dune", "build", "-p", "liquidsoap,liquidsoap-lang"
    system "opam", "exec", "--", "dune", "install", "-p", "liquidsoap,liquidsoap-lang",
           "--prefix", prefix

    # Move man pages to correct Homebrew location (share/man)
    man1.install Dir[prefix/"man/man1/*"]
    rm_r(prefix/"man")

    # Move stdlib libs to where the binary expects them (share/liquidsoap/)
    (pkgshare/"libs").install Dir[share/"liquidsoap-lang/libs/*"]
    rm_r(share/"liquidsoap-lang")

    # Copy camomile unicode data from opam switch
    camomile_share = Pathname.glob(buildpath/".opam/ocaml-system/share/camomile").first
    (pkgshare/"camomile").install Dir[camomile_share/"*"] if camomile_share&.exist?

    # Remove OCaml library artifacts not needed at runtime
    rm_r(lib/"ocaml") if (lib/"ocaml").exist?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/liquidsoap --version 2>&1")
  end
end
