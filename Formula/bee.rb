class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.98/bee-1.98.zip"
  sha256 "1ee5f4f902103d73d6711c4378e1ed14774e795778132973fadf2173ad6cc0ec"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6dc0a2c6a83e541ee2c9a4daf767b4a4dc88bde97c6454248f3311ca17970ca"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
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
