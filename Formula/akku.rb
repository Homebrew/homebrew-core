class Akku < Formula
  desc "R6RS/R7RS Scheme language package manager"
  homepage "https://akkuscm.org"
  url "https://github.com/weinholt/akku/releases/download/v1.0.0/akku-1.0.0.src.tar.xz"
  sha256 "37ac149c19cce1219595d751f9d5b99ccaffe3892ba023148dc48aab89c4bf7d"
  head "https://gitlab.com/akkuscm/akku.git"

  # TODO: Akku supports both Guile and Chez, but the actual tarball to download is
  # different depending on which you choose for running Akku. I wasn't able to get
  # the Guile version working, so this uses Chez.
  depends_on "chezscheme"

  # XXX: This is effectively a reimplementation of Akku's own install.sh, but running
  # that script via Homebrew fails for me without an error.
  def install
    chez = Formula["chezscheme"].bin/"chez"
    lib.mkpath
    (lib/"akku/bin").mkpath
    (lib/"akku/bin").install Dir["lib/akku/bin/*"]
    (lib/"akku/lib").mkpath
    (lib/"akku/lib").install Dir["lib/akku/lib/*"]
    (lib/"akku/lib/akku.chezscheme").write <<~EOS
      #!/bin/sh
      export CHEZSCHEMELIBDIRS="#{lib}/akku/lib"
      unset CHEZSCHEMELIBEXTS
      exec #{chez} --program "#{lib}/akku/bin/akku.sps" "$@"
    EOS
    ENV["CHEZSCHEMELIBDIRS"] = lib/"akku/lib"
    ENV.delete "CHEZSCHEMELIBEXTS"
    system chez, "--compile-imported-libraries", "--program", lib/"akku/bin/akku.sps"
    bin.mkpath
    bin.install lib/"akku/lib/akku.chezscheme" => "akku"
    man1.install "share/man/man1/akku.1"
  end

  test do
    expected = ",()´ Akku.scm 1.0.0 - Scheme package manager"
    assert_match shell_output("#{bin}/akku --help"), expected
  end
end
