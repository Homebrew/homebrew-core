class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.113/bee-1.113.zip"
  sha256 "94784e58ccd53f3d5a9d2c95601d253892369bf882750fe80c5bd503a5bd8794"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4228bdae803fa3f2fb3dd65f5902d5e7a2e74168d275f14b1a1765c5fd7319de"
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
