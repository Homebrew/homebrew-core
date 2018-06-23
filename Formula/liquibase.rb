class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.6.1/liquibase-3.6.1-bin.tar.gz"
  sha256 "0413e379f7d1deb5382f9fc4283ba1b7b085f7abaf6c1a3e45cbf9510accc557"

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
