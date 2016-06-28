class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?file=orientdb-community-2.2.2.tar.gz&os=mac"
  version "2.2.2"
  sha256 "1ae672fc15638526980e132b92fe1896867fa765da79eadf5adf7cdcad946f88"

  bottle do
    cellar :any_skip_relocation
    sha256 "21cce353bad1dfbc05a66cc2efe100611ba16ce394ee6ea22919519e8b92b062" => :el_capitan
    sha256 "ba8fa3dff13b14214a6b7d6389a679b37e63b4ae9be6ae7c5c92343abe7d8545" => :yosemite
    sha256 "41338bb2c9d6a7e07867f880e5de061caa0a1561d6b196a8718f6eed2bdf3731" => :mavericks
  end

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/maggiolo00/84835e0b82a94fe9970a/raw/1ed577806db4411fd8b24cd90e516580218b2d53/orientdbsh"
    sha256 "d8b89ecda7cb78c940b3c3a702eee7b5e0f099338bb569b527c63efa55e6487e"
  end

  def install
    rm_rf Dir["{bin,benchmarks}/*.{bat,exe}"]

    inreplace %W[bin/orientdb.sh bin/console.sh bin/gremlin.sh],
      '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    mkpath "#{libexec}/log"
    touch "#{libexec}/log/orientdb.err"
    touch "#{libexec}/log/orientdb.log"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => "orientdb"
    bin.install_symlink "#{libexec}/bin/console.sh" => "orientdb-console"
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => "orientdb-gremlin"
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end
end
