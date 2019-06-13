class AppuniteCache < Formula
  desc "AppUnite cache dependencies on S3 storage!"
  homepage "https://git.appunite.com/szymon.mrozek/appunite-cache"
  url "https://git.appunite.com/szymon.mrozek/appunite-cache.git",
      :tag      => "1.0.8",
      :revision => "901fe1e71c02d62934bed865f95cd15a048f74c2",
      :shallow  => false
  head "https://git.appunite.com/szymon.mrozek/appunite-cache.git", :shallow => false

  depends_on :xcode => ["10.2", :build]
  depends_on "libressl"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"appunite-cache", "verify-credentials"
  end
end
