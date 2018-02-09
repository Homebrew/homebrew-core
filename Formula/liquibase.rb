class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "http://liquibase.org"
  url "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.5.4/liquibase-3.5.4-bin.tar.gz"
  sha256 "bedb67174f1d9b024b6a323bedcec3c082426122f8f658becfd9594a4e70a324"

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
