class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/releases/download/v4.12.1/bagit-4.12.1.zip"
  sha256 "2abf838c090867e887cc46bb9f95ab697a6706ee297be8ff8ebc8dc4404ff64e"

  bottle :unneeded

  def install
    # put logs in var, not in the Cellar
    (var/"log/bagit").mkpath
    inreplace "conf/log4j.properties", "${app.home}/logs", "#{var}/log/bagit"

    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/bagit"
  end

  test do
    system bin/"bagit"
  end
end
