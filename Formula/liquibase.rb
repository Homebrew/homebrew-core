class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.4.3/liquibase-4.4.3.tar.gz"
  sha256 "b5dfa605ffc9853c39bef96ea72965a59d9ee12a3bcb59040b539d4782d4bff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c2fac1b71e4d6597c58ef46dc07e4db53cd91f56810f0670096fe88627fe9f8"
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
