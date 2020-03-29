class Bagit < Formula
  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://github.com/LibraryOfCongress/bagit-java"
  url "https://github.com/LibraryOfCongress/bagit-java/releases/download/v4.12.3/bagit-v4.12.3.zip"
  sha256 "7736d00fafe575ea298788a8d697a2af490dd12f856b43cd57bf579a374199e1"
  revision 1

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
