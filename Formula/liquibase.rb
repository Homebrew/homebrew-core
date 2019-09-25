class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.8.0/liquibase-3.8.0-bin.tar.gz"
  sha256 "d6d940dd924b0acdb2a57203578182e42d72ffdb375526c6f6b70354acc40f76"

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
