class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.15.5/bundletool-all-1.15.5.jar"
  sha256 "0ebac88764e16b2154aa7506187917d169959338ad9d510e3174bcc96c9d0f40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c51a6e1addbac32737fc9a66681ff773261095e5e675a951aa496e151ec47fd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c51a6e1addbac32737fc9a66681ff773261095e5e675a951aa496e151ec47fd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c51a6e1addbac32737fc9a66681ff773261095e5e675a951aa496e151ec47fd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c51a6e1addbac32737fc9a66681ff773261095e5e675a951aa496e151ec47fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "c51a6e1addbac32737fc9a66681ff773261095e5e675a951aa496e151ec47fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "c51a6e1addbac32737fc9a66681ff773261095e5e675a951aa496e151ec47fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd08229dcc79dc71e217b4178e712a3f2899f7087a0ca91ea707ecaf49e07ee"
  end

  depends_on "openjdk"

  resource "homebrew-test-bundle" do
    url "https://github.com/thuongleit/crashlytics-sample/raw/master/app/release/app.aab"
    sha256 "f7ea5a75ce10e394a547d0c46115b62a2f03380a18b1fc222e98928d1448775f"
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
        \tFeature module: base
        \t\tFile: res/anim/abc_fade_in.xml
      EOS

      assert_match expected, shell_output("#{bin}/bundletool validate --bundle app.aab")
    end
  end
end
