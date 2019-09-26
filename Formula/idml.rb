class Idml < Formula
  desc "Ingestion Data Mapping Language"
  homepage "http://idml.io"
  url "https://github.com/IDML/idml/releases/download/v2.0.0/idml.jar"
  sha256 "59a13e8b112bf91e2c0dd44349c00ffb8cedf61272c27d2a4fbf633f6f132fa8"

  def install
    libexec.install "idml.jar"
    bin.write_jar_script libexec/"idml.jar", "idml"
  end

  test do
    idml_version = shell_output("unzip -p #{libexec}/idml.jar META-INF/MANIFEST.MF | sed -nEe '/Specification-Version:/p'")
    assert_equal "Specification-Version: #{version}", idml_version.strip
  end
end
