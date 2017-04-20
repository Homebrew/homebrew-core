class Bee < Formula
  desc "Tool for managing database changes."
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.61/bee-1.61.zip"
  sha256 "656f52ad1e363cc204da4382452ef02fb42b8dc27f3da8378f4492aee4e6a15f"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/bee"
  end

  test do
    (testpath/"bee.properties").write <<-EOS.undent
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "dbchange:create new-file"
  end
end
