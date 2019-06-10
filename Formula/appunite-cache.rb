class AppuniteCache < Formula
  desc "AppUnite cache dependencies on S3 storage!"
  homepage "https://git.appunite.com/szymon.mrozek/appunite-cache"
  url "https://git.appunite.com/szymon.mrozek/appunite-cache.git",
      :tag      => "1.0.6",
      :revision => "e71d470acf0b2581903a8acd54a04dc7f8d4cdba",
      :shallow  => false
  head "https://git.appunite.com/szymon.mrozek/appunite-cache.git", :shallow => false

  depends_on :xcode => ["10.0", :build]
  depends_on "libressl"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end
end
