class Probatron4j < Formula
  desc "Schematron validator (use with Java 1.5 or later)"
  homepage "http://www.probatron.org"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/probatron4j/probatron4j-0.7.4.zip"
  sha256 "53f1d28d5adbc0abe8a12015a4da3a2da000e56cb1328212870d0e6fe4fe941c"

  bottle :unneeded

  def install
    libexec.install "probatron.jar", "notices"
    bin.write_jar_script libexec/"probatron.jar", "probatron"
  end
end
