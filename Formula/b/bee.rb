class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.119/bee-1.119.zip"
  sha256 "c6af3e6c6335cb43523e4c15b2d624e05a5e82034187b2a1524cfc00fdf6baef"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d22c7893c409282d2c4e036330191120ab6589f67c34810f81f78e1d8656305a"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env
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
