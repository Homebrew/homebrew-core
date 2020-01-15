class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v3.8.5/liquibase-3.8.5.tar.gz"
  sha256 "dac08f47e5065587db5a510df509a3d97908925a1be64e405a248810110a7f73"

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
