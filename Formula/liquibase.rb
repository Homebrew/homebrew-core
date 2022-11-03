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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caefb17af8afeed82b6c8e759a27a39a389571fd62e9916548509a1f7d4c3cdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caefb17af8afeed82b6c8e759a27a39a389571fd62e9916548509a1f7d4c3cdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caefb17af8afeed82b6c8e759a27a39a389571fd62e9916548509a1f7d4c3cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "b31abd175313658f69e1a5f6fc8b530d33ac06b19f53f138b591acffcbd46d34"
    sha256 cellar: :any_skip_relocation, big_sur:        "b31abd175313658f69e1a5f6fc8b530d33ac06b19f53f138b591acffcbd46d34"
    sha256 cellar: :any_skip_relocation, catalina:       "b31abd175313658f69e1a5f6fc8b530d33ac06b19f53f138b591acffcbd46d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caefb17af8afeed82b6c8e759a27a39a389571fd62e9916548509a1f7d4c3cdb"
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
