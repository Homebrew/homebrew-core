class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.120/bee-1.120.zip"
  sha256 "e0db1464ef6733ad331b15e621c01b88a1454fec15e4abd548f3722b743cc273"
  license "MPL-1.1"

  bottle do
    manifest_sha256 "2e7348d284591d771077fbff08a193146eeaac7ff412bc485ecb240af3a6980f"
    sha256 cellar: :any_skip_relocation, all: "ef273d23705a3a466ddbac54d0b8c4178efa6dec12f64fac7f192b7f67ac36fa"
  end

  depends_on "openjdk"

  deny_network_access!

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
