class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https://square.github.io/leakcanary/shark/"
  url "https://github.com/square/leakcanary/releases/download/v3.0-alpha-2/shark-cli-3.0-alpha-2.zip"
  sha256 "d57f1bbcad4392519730fbd9859a68294493d8a314a8abfec94839869f178c11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cebacc85e3f690e603a7f298e342d248c5ed6068da7edff8cfac07d4c59ab43"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    (bin/"shark-cli").write_env_script libexec/"bin/shark-cli", Language::Java.overridable_java_home_env
  end

  test do
    resource "homebrew-sample_hprof" do
      url "https://github.com/square/leakcanary/raw/v2.6/shark-android/src/test/resources/leak_asynctask_m.hprof"
      sha256 "7575158108b701e0f7233bc208decc243e173c75357bf0be9231a1dcb5b212ab"
    end

    testpath.install resource("homebrew-sample_hprof")
    assert_match "1 APPLICATION LEAKS",
                 shell_output("#{bin}/shark-cli --hprof ./leak_asynctask_m.hprof analyze").strip
  end
end
