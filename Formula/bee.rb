class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.84/bee-1.84.zip"
  sha256 "e93bf876ef9701381b677892eea5080faf8c53c2bd8bb96fa99ed31f27167e13"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5f2cb99a45afd93e3647d23c8d37b951fd3c01161f7098ccd827eba37b6daf3"
  end

  depends_on arch: :x86_64 # openjdk@8 doesn't support ARM
  depends_on "openjdk@8"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env("1.8")
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
