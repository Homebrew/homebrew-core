class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.7.1/liquibase-4.7.1.tar.gz"
  sha256 "70732c0643f947baf1459833cca68726b16adfac42f4f06ecd3cdcd641ca7385"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35cc06579e999de4d0d7eca86e8ed0ee67d8cac7818a5824106871e0bd91f641"
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
