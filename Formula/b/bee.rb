class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.117/bee-1.117.zip"
  sha256 "1706dc174d2123e06c30d8f4aa62105434f262174fd72fd1128421c353e06e98"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bfd7672e76a778253da480f733a1d25a049cfd0da09f8028512b368c456cb74"
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
