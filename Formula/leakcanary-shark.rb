class LeakcanaryShark < Formula
  desc "CLI Java memory leak explorer for LeakCanary"
  homepage "https://square.github.io/leakcanary/shark/"
  url "https://github.com/square/leakcanary/releases/download/v2.4/shark-cli-2.4.zip"
  sha256 "5f9854868873ac6c63da5903082fe4bc3e08a8e46fe5de1335a2122d8e827a9f"
  license "Apache-2.0"

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
