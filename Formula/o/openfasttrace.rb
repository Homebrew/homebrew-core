class Openfasttrace < Formula
  desc "Requirement tracing suite"
  homepage "https://github.com/itsallcode/openfasttrace"
  url "https://github.com/itsallcode/openfasttrace/releases/download/4.12.1/openfasttrace-4.12.1.jar"
  sha256 "c2fada67389e8af202d60c78bf007c8134d3b96a735705d05f52b56993eec529"
  license "GPL-3.0-only"

  bottle do
    manifest_sha256 "79ebc13a8f27dcb296fcb7ea648b0c3068136e5b597220d6161a178733c8cbd8"
    sha256 cellar: :any_skip_relocation, all: "25e0423d85f4897de73c20345a047e7323453faaf31827edb1b7ab6beb54ff0a"
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
