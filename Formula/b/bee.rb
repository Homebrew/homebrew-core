class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.106/bee-1.106.zip"
  sha256 "551a7fa8483bce0e67fe0c67f0ceecccae8e95e2d5f9aed2363dab83ef28c49d"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ceaef59b98472de5af0b83e76ef0a678f111216ae474b098faa5c7797c7aa09a"
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
