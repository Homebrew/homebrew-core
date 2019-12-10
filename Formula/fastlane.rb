class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/packaged-fastlane/archive/2.0.0.tar.gz"
  version "2.137.0"
  sha256 "5065f68499823f0137a848af7b975f4fccb4085a366f4fc2cfc27ba7e0188d41"
  head "https://github.com/fastlane/packaged-fastlane.git"

  depends_on "ruby@2.5"

  def install
    system "./install", version.to_s, prefix
  end

  def fastlane_dir_bin
    File.join(prefix, "bin")
  end

  def fastlane_executable
    File.join(fastlane_dir_bin, "fastlane")
  end

  test do
    assert_true File.exist?(fastlane_executable)
    assert_true File.exist?(File.join(prefix, "bundle-env"))
  end
end
