class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.15.4/bundletool-all-1.15.4.jar"
  sha256 "e5f54597dbb5211f050e8ddd03d4d731a9b4dfa5684c7687928b654a8ddc212a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512d90074771106a03a4e3b369252133c04c56621a2bc2ab53c7c110a7650d5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512d90074771106a03a4e3b369252133c04c56621a2bc2ab53c7c110a7650d5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512d90074771106a03a4e3b369252133c04c56621a2bc2ab53c7c110a7650d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "512d90074771106a03a4e3b369252133c04c56621a2bc2ab53c7c110a7650d5e"
    sha256 cellar: :any_skip_relocation, monterey:       "512d90074771106a03a4e3b369252133c04c56621a2bc2ab53c7c110a7650d5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "512d90074771106a03a4e3b369252133c04c56621a2bc2ab53c7c110a7650d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5b4b502e82d45e81793bf70a7666158fd1fd0c9a7966abdb23a2fc498e319f"
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
