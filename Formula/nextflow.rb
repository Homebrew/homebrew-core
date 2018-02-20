class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "https://www.nextflow.io/"
  url "https://www.nextflow.io/releases/v0.27.6/nextflow"
  sha256 "fe859cdcff7d2b515d6d5351dc7c3944945fa5549ec44d3abf395efc4e3a25bb"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle :unneeded

  # Nextflow support for Java 9 is still in beta stage and some advanced
  # features are not supported. It is suggested the use of Java version 8.
  depends_on :java => "1.8"

  def install
    bin.install "nextflow"
  end

  test do
    system bin/"nextflow", "-download"
    output = pipe_output("#{bin}/nextflow -q run -", "println 'hello'").chomp
    assert_equal "hello", output
  end
end
