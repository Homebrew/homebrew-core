class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.4.2/liquibase-4.4.2.tar.gz"
  sha256 "a8e28ccaa7f7297ee95a3b2556070f8869538b0bcc64bbe6ec389ab6648b7755"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34072818bc9e71bc223be91cfe7a1b1a6ed6314140fee46a06a8cb830388bb26"
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
