class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.23.1/liquibase-4.23.1.tar.gz"
  sha256 "b9667d97a0ba425547aa9fe66bafeccf4ef3b821e91ae732ec684d0eaf2fd7f5"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a13bdeb7a12983e76afd9f178aa764a2f807ecacd01e79993e45ef968871f21a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13bdeb7a12983e76afd9f178aa764a2f807ecacd01e79993e45ef968871f21a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a13bdeb7a12983e76afd9f178aa764a2f807ecacd01e79993e45ef968871f21a"
    sha256 cellar: :any_skip_relocation, ventura:        "5bbdd5f4585acd0157e8c7e78ce3de7a833676c3443b3bf89e600d3c70993be8"
    sha256 cellar: :any_skip_relocation, monterey:       "5bbdd5f4585acd0157e8c7e78ce3de7a833676c3443b3bf89e600d3c70993be8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bbdd5f4585acd0157e8c7e78ce3de7a833676c3443b3bf89e600d3c70993be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13bdeb7a12983e76afd9f178aa764a2f807ecacd01e79993e45ef968871f21a"
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
