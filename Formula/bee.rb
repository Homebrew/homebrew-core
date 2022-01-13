class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.92/bee-1.92.zip"
  sha256 "6fa99a3041f9ae98b56ee7cf64cd82bec4ee3f94f87b208ee2e2203516ebb76d"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8308052ce333a2628e04c5b06110004d712e68474425d18fa0b517e16b99fc7a"
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
