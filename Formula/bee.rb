class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.89/bee-1.89.zip"
  sha256 "2e2e13f2ab1040c1165933aa461a17fb2e40f6f94154077dcc30c91eff2655d9"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "42ff5183c5de19d0b30e28c7866b54348ef77826077b25dbc4d22409bf941a4f"
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
