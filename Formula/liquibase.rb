class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.5.0/liquibase-4.5.0.tar.gz"
  sha256 "4ce45bcbe4660b33eee93e80b9be968631e85566d02d90c0c5306fac8d4dd602"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98edbbdb5cd605cdd72e886130e66cad61b54a7b4de65203ecbbf6e69c763562"
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
