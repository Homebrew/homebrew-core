class Openfasttrace < Formula
  desc "Requirement tracing suite"
  homepage "https://github.com/itsallcode/openfasttrace"
  url "https://github.com/itsallcode/openfasttrace/releases/download/4.11.0/openfasttrace-4.11.0.jar"
  sha256 "f094cd314f0fc4236f513f66fb39260a16f72e2320beb6b4fdeb7940b9b8cf87"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ac3e3e4b3f754b2ca13027ff6c1601a37e1859d6d307e506a197ca5365cfa52"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    libexec.install "openfasttrace-#{version}.jar"
    bin.write_jar_script libexec/"openfasttrace-#{version}.jar", "oft"
  end

  test do
    (testpath/"trace.md").write <<~MARKDOWN
      # Features
      `feat~tracing~1`

      Needs: req

      # Requirements
      `req~sample.requirement~1`

      Covers:
      * `feat~tracing~1`

      Needs: dsn

      # Design
      `dsn~sample.design~1`

      Covers:
      * `req~sample.requirement~1`
    MARKDOWN

    assert_equal "ok - 3 total", shell_output("#{bin}/oft trace --color-scheme BLACK_AND_WHITE #{testpath}").strip
  end
end
