class Fregerepl < Formula
  desc "Formula for installing the Frege REPL (not the compiler!!!)"
  homepage "https://github.com/Frege/frege-repl"
  url "https://github.com/Frege/frege-repl/releases/download/1.4-SNAPSHOT/frege-repl-1.4-SNAPSHOT.zip"
  version "1.4-SNAPSHOT"
  sha256 "2cf1c2a8f7b64c9d70b21fbfd25b2af3f5e3bebe3662f724afd435d01bddafec"

  depends_on :java => "1.8+"

  def install
    # Before we even get here, Homebrew has already unpacked the zip file.

    # Get rid of Windows batch file since Homebrew only runs on OS X.
    rm_f Dir["bin/*.bat"]

    # Move both bin and lib directories under libexec to avoid putting jars
    # into /usr/local/lib (per Homebrew recommendations) while preserving
    # the need for the shell script to reference jar files in a parallel
    # directory and not having to tamper with the original shell script.
    libexec.install "bin", "lib"

    # Symlink to the real script.
    bin.install_symlink "#{libexec}/bin/frege-repl"
  end

  test do
    assert_match "65536", pipe_output("#{bin}/frege-repl", "println $ 64*1024\n:quit\n")
  end
end
