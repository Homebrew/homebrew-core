class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.120/bee-1.120.zip"
  sha256 "e0db1464ef6733ad331b15e621c01b88a1454fec15e4abd548f3722b743cc273"
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
