class Openfasttrace < Formula
  desc "Requirement tracing suite"
  homepage "https://github.com/itsallcode/openfasttrace"
  url "https://github.com/itsallcode/openfasttrace/releases/download/4.10.0/openfasttrace-4.10.0.jar"
  sha256 "8449a1652f140841a89fb053b71130b9c880fe2b7dd06f3490ae9c740a0c5e08"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad2e71f486edb3447495b607d196c4b478d44022b5078970984d4476a860e45e"
  end

  depends_on "openjdk"

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
