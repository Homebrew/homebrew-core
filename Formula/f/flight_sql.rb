class FlightSql < Formula
  desc "Apache Arrow Flight SQL Server - with DuckDB and SQLite back-ends"
  homepage "https://arrow.apache.org/docs/format/FlightSql.html"
  url "https://github.com/voltrondata/flight-sql-server-example.git",
      tag:      "v1.1.19",
      revision: "96f9831a901c4660c9cfb6cf299a682ef9614bb2"
  license "Apache-2.0"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3" => :build
  depends_on xcode: :build
  depends_on :macos

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "-S", "..", *std_cmake_args, "-G", "Ninja"
      system "cmake", "--build", ".", "--target", "install"
      bin.install "flight_sql"
    end
  end

  test do
    assert_equal "Flight SQL Server CLI: v1.1.19", shell_output("#{bin}/flight_sql --version").strip
  end
end
