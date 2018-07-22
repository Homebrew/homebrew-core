class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.6.2/liquibase-3.6.2-bin.tar.gz"
  sha256 "dd6d6c81b7ed6c75ee32d51bb53b3449fe2a695684965e36014ff70ea65c3ea5"

  bottle :unneeded

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink libexec/"liquibase"
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
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
