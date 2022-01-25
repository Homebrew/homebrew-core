class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.93/bee-1.93.zip"
  sha256 "4c4ee0fcef31dcedc524442c53e39eb18546dba65dfc8241df8c86de6b6ec185"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c239cc9b877e8debf86e5a830056fd8356069e60b153b87138a82943041ac42"
  end

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
