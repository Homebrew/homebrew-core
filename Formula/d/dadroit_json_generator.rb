# typed: true
# frozen_string_literal: true

# DadroitJsonGenerator: Generates nested JSON data using custom templates.
class DadroitJsonGenerator < Formula
  desc "Generate nested JSON sample data using custom templates"
  homepage "https://github.com/DadroitOrganization/Generator"
  url "https://github.com/DadroitOrganization/Generator/releases/download/Release_Version_1.0.0.370/JSONGeneratorCLI-Homebrew.zip"
  sha256 "72b030cb5e9aecc871f34758bd5c5a899adfe1f5498041a6a44a225a3580b88d"
  license "GPL-3.0-or-later"

  # Dependency on Free Pascal Compiler
  depends_on "fpc" => :build

  def install
    system "make"
    # You can use the tool by running this command, followed by the path to the template json file
    bin.install "JSONGeneratorCLI"
  end

  test do
    # Writing a sample JSON template for testing
    (testpath/"sample.json").write <<~EOS
      {
          "Name": "$FirstName",
          "Value": {"X": 1, "Y": 2},wind
          "Books": {"$Random": ["B1", "B2", "B3"]},
          "Age": {"$Random": {"$Min": 10, "$Max": 20}}
      }
    EOS
    # Testing if the tool generates the expected output file
    system "#{bin}/JSONGeneratorCLI", "sample.json"
    assert_predicate testpath/"sample.out.json", :exist?, "JSON output file 'sample.out.json' should be created"
  end
end
