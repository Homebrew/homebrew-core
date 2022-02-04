class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.95/bee-1.95.zip"
  sha256 "f999eca2d55a0d0ab9644be16b96dc2664a4b31ecbfad1990d8bb3c03ec4102b"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf59eb6827e0d33edacf1164f78521373af8d86d805aef10e5085338ac34135b"
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
