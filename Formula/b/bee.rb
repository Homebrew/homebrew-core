class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.112/bee-1.112.zip"
  sha256 "6aa0c80772fa3a1d43bd0a74f2bdc6fb4a3dda52db184392aefa69e0bbf226de"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3284eecac0a317fa50136240049610186be0dadb11f6009c888f331ed931def"
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
