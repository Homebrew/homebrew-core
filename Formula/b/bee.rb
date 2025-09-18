class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.110/bee-1.110.zip"
  sha256 "ccddd2ab86ecfdb723de6917fca596aeabc9df44d36ad58432b3f2a4c72f10b7"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6403967c67cdb228ea22dd5cb24121c5de8d33f4db951555034d232ba462a8be"
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
