class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.15.1/bundletool-all-1.15.1.jar"
  sha256 "aec9dc64fb25acc64eb668b45c0ec6a0ebba30db4a2e084b61b7af0a7380a0e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36433c7af483baf649eb67e5a3b568c7be4a03088993564a809f8e79eb562ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36433c7af483baf649eb67e5a3b568c7be4a03088993564a809f8e79eb562ed9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36433c7af483baf649eb67e5a3b568c7be4a03088993564a809f8e79eb562ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "36433c7af483baf649eb67e5a3b568c7be4a03088993564a809f8e79eb562ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "36433c7af483baf649eb67e5a3b568c7be4a03088993564a809f8e79eb562ed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "36433c7af483baf649eb67e5a3b568c7be4a03088993564a809f8e79eb562ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c3e13ffeb2efdee10921278c557a6315b6e54743776786248c64ef97f49c9f"
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
