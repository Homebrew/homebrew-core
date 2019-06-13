class AppuniteCache < Formula
  desc "AppUnite cache dependencies on S3 storage!"
  homepage "https://git.appunite.com/szymon.mrozek/appunite-cache"
  url "https://git.appunite.com/szymon.mrozek/appunite-cache.git",
      :tag      => "1.0.7",
      :revision => "d7521a87c8c3aa95575df93c5d6b6af5966020a4",
      :shallow  => false
  head "https://git.appunite.com/szymon.mrozek/appunite-cache.git", :shallow => false

  depends_on :xcode => ["10.2", :build]
  depends_on "libressl"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test
    system bin/"appunite-cache", "verify-credentials"
  end
end
