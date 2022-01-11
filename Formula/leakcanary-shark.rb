class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https://square.github.io/leakcanary/shark/"
  url "https://github.com/square/leakcanary/releases/download/v2.8.1/shark-cli-2.8.1.zip"
  sha256 "096b8764dcebbe65b2cb212aecf2ac51385a245c24975acfe774f798da64579b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d7fe93f99b897f960ead987304acbf97d61c121a713f8f935c7781cd0aa8adc"
  end

  depends_on "openjdk"

  resource "sample_hprof" do
    url "https://github.com/square/leakcanary/raw/v2.6/shark-android/src/test/resources/leak_asynctask_m.hprof"
    sha256 "7575158108b701e0f7233bc208decc243e173c75357bf0be9231a1dcb5b212ab"
  end

  def install
    # Remove Windows scripts
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    (bin/"shark-cli").write_env_script libexec/"bin/shark-cli", Language::Java.overridable_java_home_env
  end

  test do
    resource("sample_hprof").stage do
      assert_match "1 APPLICATION LEAKS",
                   shell_output("#{bin}/shark-cli --hprof ./leak_asynctask_m.hprof analyze").strip
    end
  end
end
