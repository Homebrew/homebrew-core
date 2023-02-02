class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.19.0/liquibase-4.19.0.tar.gz"
  sha256 "2ec24cacf1dc6794cde139de9778854839ee1d3fa9c134fefa92157401e57134"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b32ce8651a511c5d9620315b2dfdd79fbcf1aae1eba56c98ef0b9ea73bb65a72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b32ce8651a511c5d9620315b2dfdd79fbcf1aae1eba56c98ef0b9ea73bb65a72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b32ce8651a511c5d9620315b2dfdd79fbcf1aae1eba56c98ef0b9ea73bb65a72"
    sha256 cellar: :any_skip_relocation, ventura:        "47b3c4b1b333ed80b647b17de6426b6ff27fef8dce2ab1fd1927964dc34936c3"
    sha256 cellar: :any_skip_relocation, monterey:       "47b3c4b1b333ed80b647b17de6426b6ff27fef8dce2ab1fd1927964dc34936c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "47b3c4b1b333ed80b647b17de6426b6ff27fef8dce2ab1fd1927964dc34936c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b32ce8651a511c5d9620315b2dfdd79fbcf1aae1eba56c98ef0b9ea73bb65a72"
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
