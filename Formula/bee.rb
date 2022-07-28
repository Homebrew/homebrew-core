class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.98/bee-1.98.zip"
  sha256 "1ee5f4f902103d73d6711c4378e1ed14774e795778132973fadf2173ad6cc0ec"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95a35b0bb062508bb8b7fcc3f79e485ddc4f06583f41b272d397f347ec93662e"
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
