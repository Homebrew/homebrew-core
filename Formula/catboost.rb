class Catboost < Formula
  desc "Fast, scalable, high performance Gradient Boosting on Decision Trees library"
  homepage "https://catboost.ai"
  url "https://github.com/catboost/catboost/archive/v0.24.4.tar.gz"
  sha256 "03df498249206519b7e37ff8067cf265a2826afc4305a32f97986fbe308994da"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  resource "yandex" do
    url "https://storage.mds.yandex.net/get-devtools-opensource/471749/1903567586"
    sha256 "cb97bd28c8205c18bf9426b9457616e2fd05121562c72dcbba1ee7eca53a5034"
  end

  def install
    cd "#{buildpath}/catboost/app" do
      ENV["YA_CACHE_DIR"] = "./.ya"
      system "../../ya", "make", "-r", "-o", "#{buildpath}/build"
      bin.install "#{buildpath}/build/catboost/app/catboost"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/catboost --version")
  end
end
