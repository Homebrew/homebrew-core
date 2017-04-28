class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/releases/download/v5.0.0/bagit-5.0.0.jar"
  sha256 "b742b19927264a870ae4adab1507cb9995918e9962e9281bd3bb3bfd8e461fb3"

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
