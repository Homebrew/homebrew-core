class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.16.0/bundletool-all-1.16.0.jar"
  sha256 "8207996f83a2839afd5ad6e8532da7485ea06874b8062a21a94b3e2eb97eb396"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58e9eb96aae28d6cd2a6db238aeeaddb60d1addad02073607232a2574573177f"
  end

  depends_on "openjdk"

  def install
    libexec.install "bundletool-all-#{version}.jar" => "bundletool-all.jar"
    bin.write_jar_script libexec/"bundletool-all.jar", "bundletool"
  end

  test do
    resource "homebrew-test-bundle" do
      url "https://github.com/thuongleit/crashlytics-sample/raw/master/app/release/app.aab"
      sha256 "f7ea5a75ce10e394a547d0c46115b62a2f03380a18b1fc222e98928d1448775f"
    end

    resource("homebrew-test-bundle").stage do
      expected = <<~EOS
        App Bundle information
        ------------
        Feature modules:
        \tFeature module: base
        \t\tFile: res/anim/abc_fade_in.xml
      EOS

      assert_match expected, shell_output("#{bin}/bundletool validate --bundle app.aab")
    end
  end
end
