class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.24.0/liquibase-4.24.0.tar.gz"
  sha256 "6ecf638a75b501b798189da824e167f29db93477186109f2549508c6266d0b2a"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13b396983d4f40083cd5c26d75225f9ea43ab558e4ff2575209dec875c741d8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b396983d4f40083cd5c26d75225f9ea43ab558e4ff2575209dec875c741d8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b396983d4f40083cd5c26d75225f9ea43ab558e4ff2575209dec875c741d8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e18985f4586c9be417725c182e127e80420e2358404fcea27bd83dba6f5970fe"
    sha256 cellar: :any_skip_relocation, ventura:        "e18985f4586c9be417725c182e127e80420e2358404fcea27bd83dba6f5970fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e18985f4586c9be417725c182e127e80420e2358404fcea27bd83dba6f5970fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b396983d4f40083cd5c26d75225f9ea43ab558e4ff2575209dec875c741d8c"
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
