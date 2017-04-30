class ApkPatchSizeEstimator < Formula
  desc "Estimates the size of Play patches / gzipped APKs."
  homepage "https://github.com/googlesamples/apk-patch-size-estimator"
  url "https://github.com/googlesamples/apk-patch-size-estimator/archive/0.2.tar.gz"
  sha256 "cbab54effbbbb2abf3ddb58cf004e8ee0e38b520fbc5266f08a5fd6a8cf9c9ff"
  depends_on "bsdiff"

  def install
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/*.py") do |script|
      bin.install_symlink script => File.basename(script, ".py").tr("_", "-")
    end
  end

  test do
    assert_match /^usage: apk-patch-size-estimator/, shell_output("#{bin}/apk-patch-size-estimator --help").strip
  end
end
