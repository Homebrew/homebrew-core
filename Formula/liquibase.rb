class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v3.8.4/liquibase-3.8.4.tar.gz"
  sha256 "d74cd6962b92e8af7f6efd1e0ea58cbf2d0be7a889a24fc86de2441619b30db1"

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
