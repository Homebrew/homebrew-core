class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.6.0/liquibase-3.6.0-bin.tar.gz"
  sha256 "8bcaaf5f839d5e5dd03d758c6ca3c1f2691ee894c8f713694164170d90fb3a5b"

  bottle :unneeded

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink libexec/"liquibase"
  end

  def caveats; <<~EOS
    You should set the environment variable LIQUIBASE_HOME to
      #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
