class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.11.1/bundletool-all-1.11.1.jar"
  sha256 "66593ac144017edb2df13c7e7404faeff581203d411c3e1a480bd17063bd12b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0fb79f18b633c9b225119733ca0632c9590170b25fdd460cb5ffd32e6b4e56ab"
  end

  depends_on "openjdk"

  resource "homebrew-test-bundle" do
    url "https://gist.githubusercontent.com/raw/ca85ede7ac072a44f48c658be55ff0d3/sample.aab"
    sha256 "aac71ad62e1f20dd19b80eba5da5cb5e589df40922f288fb6a4b37a62eba27ef"
  end

  def install
    libexec.install "bundletool-all-#{version}.jar" => "bundletool-all.jar"
    bin.write_jar_script libexec/"bundletool-all.jar", "bundletool"
  end

  test do
    resource("homebrew-test-bundle").stage do
      expected = <<~EOS
        App Bundle information
        ------------
        Feature modules:
        	Feature module: base
        		File: dex/classes.dex
      EOS

      assert_equal expected, shell_output("#{bin}/bundletool validate --bundle sample.aab")
    end
  end
end
