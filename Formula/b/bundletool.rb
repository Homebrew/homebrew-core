class Bundletool < Formula
  desc "Command-line tool to manipulate Android App Bundles"
  homepage "https://github.com/google/bundletool"
  url "https://github.com/google/bundletool/releases/download/1.17.1/bundletool-all-1.17.1.jar"
  sha256 "45881ead13388872d82c4255b195488b7fc33f2cac5a9a977b0afc5e92367592"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c958bb9d76d4912791111674b31994dfb7a20e45bd2bfa3a830bc3f0fb99895d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68eb7b3df648ebbfbbd45818938d79d1db458fb613b25d96791a6783882c69f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68eb7b3df648ebbfbbd45818938d79d1db458fb613b25d96791a6783882c69f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68eb7b3df648ebbfbbd45818938d79d1db458fb613b25d96791a6783882c69f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bb53345f5406e2ea06406c44d6db71cef7da29a89d307ea8dbb299daf44228c"
    sha256 cellar: :any_skip_relocation, ventura:        "8bb53345f5406e2ea06406c44d6db71cef7da29a89d307ea8dbb299daf44228c"
    sha256 cellar: :any_skip_relocation, monterey:       "68eb7b3df648ebbfbbd45818938d79d1db458fb613b25d96791a6783882c69f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50480a4d62a2aa54f98482248944ff53bf16ac96c8b49a24c58f0f04ac278dc9"
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
