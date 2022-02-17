class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.96/bee-1.96.zip"
  sha256 "6f2ee8ad9b86d12b0e82211f74f551ba0ad88c9505dbf03e488a40d678eb9248"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dafd1f5d70b1d88ef5cd43f2a53e2aab92eedbe9d4ed069d3e7573cfc8d903a0"
  end

  depends_on "openjdk@8"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end
