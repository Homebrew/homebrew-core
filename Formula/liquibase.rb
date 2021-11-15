class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.6.1/liquibase-4.6.1.tar.gz"
  sha256 "9d1e33c9ef5c0d545554586d656ab5b9e8c6f8963b0eb3a0e6caea3ad9b90795"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99370e7302eb02c7927604b7c3a8e0f69a2d335715e57e691e3c8c88acbbbb94"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", JAVA_HOME: Formula["openjdk"].opt_prefix
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
