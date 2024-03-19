class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.15.6/bundletool-all-1.15.6.jar"
  sha256 "38ae8a10bcdacef07ecce8211188c5c92b376be96da38ff3ee1f2cf4895b2cb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f220b43e7cc35d4d81c96f83e0a4df119b7844056564920c2fa05eabc0aa8439"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f220b43e7cc35d4d81c96f83e0a4df119b7844056564920c2fa05eabc0aa8439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f220b43e7cc35d4d81c96f83e0a4df119b7844056564920c2fa05eabc0aa8439"
    sha256 cellar: :any_skip_relocation, sonoma:         "f220b43e7cc35d4d81c96f83e0a4df119b7844056564920c2fa05eabc0aa8439"
    sha256 cellar: :any_skip_relocation, ventura:        "f220b43e7cc35d4d81c96f83e0a4df119b7844056564920c2fa05eabc0aa8439"
    sha256 cellar: :any_skip_relocation, monterey:       "f220b43e7cc35d4d81c96f83e0a4df119b7844056564920c2fa05eabc0aa8439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea62556f28c7b01f47b806d11d78f79ffbd2f647c4e187a8b04eff692f51685"
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
