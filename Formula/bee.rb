class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.80/bee-1.80.zip"
  sha256 "42441cd6e48f1dc491b33384e4c80e72425bca660f4fb1c6e830840c3a397e7d"
  license "MPL-1.1"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4224f9390bdaaa778b634dd75e0b5092ba049626b8e9d9dc33f89aa9cfbdefd"
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
