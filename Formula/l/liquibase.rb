class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.29.2/liquibase-4.29.2.tar.gz"
  sha256 "1d017a206a95ab3076a52f660679c2d80b9f2174942cb0715e35d53931e20ee9"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "089b8379fbd8bc9e5a04a86fa3afdbfb095d866904b683a440647ca12b2a4698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "089b8379fbd8bc9e5a04a86fa3afdbfb095d866904b683a440647ca12b2a4698"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "089b8379fbd8bc9e5a04a86fa3afdbfb095d866904b683a440647ca12b2a4698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089b8379fbd8bc9e5a04a86fa3afdbfb095d866904b683a440647ca12b2a4698"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3ebbe6c16c115e2d2b26787a8d6ca49e3781ac8b88a06d5b30afe581a7f71af"
    sha256 cellar: :any_skip_relocation, ventura:        "c3ebbe6c16c115e2d2b26787a8d6ca49e3781ac8b88a06d5b30afe581a7f71af"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ebbe6c16c115e2d2b26787a8d6ca49e3781ac8b88a06d5b30afe581a7f71af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089b8379fbd8bc9e5a04a86fa3afdbfb095d866904b683a440647ca12b2a4698"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])

    chmod 0755, "liquibase"
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
    system bin/"liquibase", "--version"
  end
end
