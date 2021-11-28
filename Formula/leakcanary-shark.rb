class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https://square.github.io/leakcanary/shark/"
  url "https://github.com/square/leakcanary/releases/download/v2.7/shark-cli-2.7.zip"
  sha256 "6a4198deec2369f6b7e03e4a0175eb1cdba74b02989159f652b729016e140468"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8aed4f0031bed4e36ef53b59e12a9c109fdb28a275ea6c79273e3b81173eeb0b"
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
