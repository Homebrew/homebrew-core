class MongodbShell < Formula
  desc "The interactive mongo shell to MongoDB"
  homepage "https://docs.mongodb.com/manual/mongo/"
  url "https://downloads.mongodb.org/osx/mongodb-shell-osx-ssl-x86_64-4.0.6.tgz"
  sha256 "bcc6c3da65dcdb62b09b044a7f578e0caada5ac1051f6ef41456bc517a542b6a"

  bottle :unneeded

  conflicts_with "mongodb"

  def install
    bin.install "bin/mongo"
  end

  test do
    system bin/"mongo", "--help"
  end
end
