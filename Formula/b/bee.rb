class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.102/bee-1.102.zip"
  sha256 "992a20a0f2dda1408b33395214c42142962ff111c62bfbdd8ac6933995fd32a2"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "767fe6a22c427a0785aa32ba6c9a33d6f51147d52d3bcb058d3d426675f1a5cd"
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
