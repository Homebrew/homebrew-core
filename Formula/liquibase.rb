class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.4.0/liquibase-4.4.0.tar.gz"
  sha256 "8aa5900195751f7a7d51dfba5364702297c596cbbeed213de806e1deef02095b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d2fc5d561f0b2c67019fee9a8f9fb60723bfe8fd318bf32713857e48681cada"
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
