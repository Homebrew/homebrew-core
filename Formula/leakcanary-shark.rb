class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https://square.github.io/leakcanary/shark/"
  url "https://github.com/square/leakcanary/releases/download/v2.3/shark-cli-2.3.zip"
  sha256 "462c48209f8f4e887d068a7ccc76ebcc14eaab0ebd08e05c2f8ab9eb5d553a90"

  bottle :unneeded

  depends_on "openjdk"

  resource "sample_hprof" do
    url "https://github.com/square/leakcanary/raw/v2.2/shark-android/src/test/resources/leak_asynctask_m.hprof"
    sha256 "7575158108b701e0f7233bc208decc243e173c75357bf0be9231a1dcb5b212ab"
  end

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("sample_hprof").stage do
      assert_match "1 APPLICATION LEAKS",
                   shell_output("#{bin}/shark-cli --hprof ./leak_asynctask_m.hprof analyze").strip
    end
  end
end
