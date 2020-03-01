class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/archive/5.2.0.tar.gz"
  sha256 "52b1bed98ce89f5411017dc7f10f7b8cc201cc97fad899a53799ff8658d499af"

  bottle :unneeded

  depends_on "openjdk"

  def install
    # put logs in var, not in the Cellar
    (var/"log/bagit").mkpath
    inreplace "conf/log4j.properties", "${app.home}/logs", "#{var}/log/bagit"

    libexec.install Dir["*"]

    (bin/"bagit").write_env_script libexec/"bin/bagit",
                                   :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"bagit"
  end
end
