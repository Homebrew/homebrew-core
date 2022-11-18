class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.17.2/liquibase-4.17.2.tar.gz"
  sha256 "85e910880006bdccfd7d6805a4601bff3311f4eadebc68081b4bfeac5ec7af40"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.org/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3635eae0708c9dd3c80b9d6490e4c42da59dfbb11fa0f61293d0fe89e28d06f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3635eae0708c9dd3c80b9d6490e4c42da59dfbb11fa0f61293d0fe89e28d06f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3635eae0708c9dd3c80b9d6490e4c42da59dfbb11fa0f61293d0fe89e28d06f7"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf944beaa473f79a52be58ef68ecbfe4ff8058c9b3bb42e30e106faabed31ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf944beaa473f79a52be58ef68ecbfe4ff8058c9b3bb42e30e106faabed31ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecf944beaa473f79a52be58ef68ecbfe4ff8058c9b3bb42e30e106faabed31ca"
    sha256 cellar: :any_skip_relocation, catalina:       "ecf944beaa473f79a52be58ef68ecbfe4ff8058c9b3bb42e30e106faabed31ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3635eae0708c9dd3c80b9d6490e4c42da59dfbb11fa0f61293d0fe89e28d06f7"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
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
