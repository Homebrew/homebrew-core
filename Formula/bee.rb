class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.64/bee-1.64.zip"
  sha256 "31a0f5cef32fc2e2221ded3b1ff02cd0f47d141e8433a1b11f8d7159f7d9bb5c"

  bottle :unneeded

  depends_on :java => "1.8"

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
    system bin/"bee", "-d", testpath/"bee", "dbchange:create new-file"
  end
end
