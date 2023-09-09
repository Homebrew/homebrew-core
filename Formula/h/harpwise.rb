require "fileutils"

class Harpwise < Formula
  desc "Harmonica practice-utility for the command-line using microphone and speaker"
  homepage "https://github.com/marcIhm/harpwise"
  url "https://github.com/marcihm/harpwise/archive/4.4.4.tar.gz"
  sha256 "7caae0c4732bb188d164d86a4cceb2aa7b4f09859b945bc86f42d31500571e83"
  license "MIT"

  # dependencies ordered according to "brew style harpwise"
  depends_on "aubio"
  depends_on "coreutils"
  depends_on "figlet"
  depends_on "ruby"
  depends_on "sox"
  depends_on "toilet"

  def install
    # harpwise is written in ruby, but is not a gem.
    man1.install "man/harpwise.1" => "harpwise.1"
    mkdir "bin"
    File.write("bin/harpwise", "#!/bin/bash\n\n#{prefix}/harpwise $@\n")
    bin.install("bin/harpwise")
    prefix.install Dir["*"]
  end

  test do
    # Selftest for frequency-pipeline (sox + aubio) and generation of
    # big chars (figlet + toilet).  For a much more extensive
    # test-suite see test/run_tests.rb.
    system "#{bin}/harpwise", "develop", "selftest"
  end
end
