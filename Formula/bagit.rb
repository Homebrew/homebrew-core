class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/releases/download/v4.12.2/bagit-4.12.2.zip"
  sha256 "6fa04f2d5f679894bd0dfcf0b2023dabdf6b2c254da6c28c9a226e8b5bf8303c"

  bottle :unneeded

  depends_on :java => "1.8+"

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
