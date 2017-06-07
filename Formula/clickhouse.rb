class Clickhouse < Formula
  desc "is an open-source column-oriented database management system."
  homepage "https://clickhouse.yandex/"
  url "https://github.com/yandex/ClickHouse/archive/v1.1.54074-stable.tar.gz"
  version "1.1.54074"
  sha256 "5e1d0b825828381c5c081d2af3da73eb35ea2a986b4df606b0990e57e96ddc28"
  head "https://github.com/yandex/ClickHouse.git"

  devel do
    url "https://github.com/yandex/ClickHouse/archive/v1.1.54078-testing.tar.gz"
    version "1.1.54078"
    sha256 "3fdb1b7b2e5b51700777d116fad753e3f3371b981e2d35c9cea5c39845b40ad1"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  # We have to force some env vars here to force boost to be built from source
  ENV["HOMEBREW_CC"] = "gcc-6"
  ENV["HOMEBREW_LD"] = "gcc-6"
  ENV["HOMEBREW_CXX"] = "g++-6"
  ENV["HOMEBREW_BUILD_FROM_SOURCE"] = "1"

  depends_on "boost" => :build

  ENV["HOMEBREW_BUILD_FROM_SOURCE"] = "0"

  depends_on "icu4c" => :build
  depends_on "mysql" => :build
  depends_on "openssl" => :build
  depends_on "unixodbc" => :build
  depends_on "glib" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build
  depends_on "readline" => :recommended

  def install
    ENV["DISABLE_MONGODB"] = "1"

    # Hardcode the version assignment since there's no git repository
    inreplace "libs/libcommon/src/get_revision_lib.sh", /git.*\n.*/, "echo " + version.to_s[-5..-1]

    mkdir "build"
    cd "build" do
      system "cmake", ".."
      system "make"
      bin.install "#{buildpath}/build/dbms/src/Server/clickhouse" => "clickhouse-server"
      bin.install_symlink "clickhouse-server" => "clickhouse-client"
    end

    mkdir "#{var}/clickhouse"

    inreplace "#{buildpath}/dbms/src/Server/config.xml" do |s|
      s.gsub! "/opt/clickhouse/", "#{var}/clickhouse/"
      s.gsub! "<!-- <max_open_files>262144</max_open_files> -->", "<max_open_files>262144</max_open_files>"
    end

    # Copy configuration files
    mkdir "#{etc}/clickhouse-client/"
    mkdir "#{etc}/clickhouse-server/"
    mkdir "#{etc}/clickhouse-server/config.d/"
    mkdir "#{etc}/clickhouse-server/users.d/"

    (etc/"clickhouse-client").install "#{buildpath}/dbms/src/Client/config.xml"
    (etc/"clickhouse-server").install "#{buildpath}/dbms/src/Server/config.xml"
    (etc/"clickhouse-server").install "#{buildpath}/dbms/src/Server/users.xml"
  end

  def caveats; <<-EOS.undent
    The configuration files are available at:
      #{etc}/clickhouse-client/
      #{etc}/clickhouse-server/
    The database itself will store data at:
      #{var}/clickhouse/

    If you're going to run the server, make sure to increase `maxfiles` limit:
      https://github.com/yandex/ClickHouse/blob/master/MacOS.md
  EOS
  end

  test do
    system "#{bin}/clickhouse-client", "--help"
  end
end
