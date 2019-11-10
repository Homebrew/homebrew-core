class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/0.11.0/bundletool-all-0.11.0.jar"
  sha256 "f869bd8b580065c0a983b69d30497293cc8ebcec03b1b20b74f1ab87b98455eb"

  bottle :unneeded
  depends_on :java => "1.8+"

  resource "bundle" do
    url "https://gist.githubusercontent.com/raw/ca85ede7ac072a44f48c658be55ff0d3/sample.aab"
    sha256 "aac71ad62e1f20dd19b80eba5da5cb5e589df40922f288fb6a4b37a62eba27ef"
  end

  def install
    libexec.install "bundletool-all-#{version}.jar"
    bin.write_jar_script libexec/"bundletool-all-#{version}.jar", "bundletool"
  end

  test do
    resource("bundle").stage do
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
