class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.5.1/liquibase-3.5.1-bin.tar.gz"
  sha256 "b99870efec8c779b4e279a8b0c730273f837d4b6dffd037176737ecc0641ab6b"

  bottle :unneeded

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink libexec/"liquibase"
  end

  def caveats; <<-EOS.undent
    You should set the environment variable LIQUIBASE_HOME to
      #{libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
