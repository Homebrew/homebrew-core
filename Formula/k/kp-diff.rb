class KpDiff < Formula
  desc "CLI utility to diff KeePass database"
  homepage "https://github.com/aivanovski/kp-diff"
  url "https://github.com/aivanovski/kp-diff/releases/download/0.5.1/kp-diff.jar"
  sha256 "e0c7d7b1bf6895a7f5cfb976fb6a33034b0ac5554b1ce21a4db6ede70c4556df"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    libexec.install "kp-diff.jar"
    bin.write_jar_script libexec/"kp-diff.jar", "kp-diff"
  end

  test do
    # Setup test files
    resource "test-db" do
      url "https://raw.githubusercontent.com/aivanovski/kp-diff/main/test-db/demo.kdbx"
      sha256 "3f76124c32ec0a79fa5e9a532631f5cb31c8a8cc485c3add5b740f30d03c5f8f"
    end

    resource "test-modified-db" do
      url "https://raw.githubusercontent.com/aivanovski/kp-diff/main/test-db/demo-modified.kdbx"
      sha256 "34be62102dd3777adcbad8218a9cf391e0083061d881313271b1e81f806a8924"
    end

    resource "test-key" do
      url "https://raw.githubusercontent.com/aivanovski/kp-diff/main/test-db/key.keyx"
      sha256 "aec1e7303d91d22a5047ec78719df0f3ba5b0358e26ca1a8eee8d7df11f1e4e8"
    end

    testpath.install resource("test-db")
    testpath.install resource("test-modified-db")
    testpath.install resource("test-key")

    # Setup expected output
    expected_output = [
      "~ Group 'Root'",
      "~     Entry 'Test entry'",
      "~         Field 'Notes': '' Changed to 'Notes were added'",
    ]

    # Assert expected output matches actual
    output = shell_output("#{bin}/kp-diff demo.kdbx demo-modified.kdbx --key-file key.keyx --no-color")
    assert_equal expected_output.join("\n"), output.strip
  end
end
