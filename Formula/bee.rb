class Bee < Formula
  desc "Tool for managing database changes."
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.62/bee-1.62.zip"
  sha256 "efc008e39b258749de837f820f308d86b7dc7f040be5e8cd0a045dcb7a728d89"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/bee"
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "dbchange:create new-file"
  end
end
