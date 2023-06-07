class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.22.0/liquibase-4.22.0.tar.gz"
  sha256 "caa019320608313709593762409a70943f9678fcc8e1ba19b5b84927f53de457"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21c07b0d9fbc02e1eb6df9acd81b60f5a69c36830063dcb014989536d528058a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21c07b0d9fbc02e1eb6df9acd81b60f5a69c36830063dcb014989536d528058a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21c07b0d9fbc02e1eb6df9acd81b60f5a69c36830063dcb014989536d528058a"
    sha256 cellar: :any_skip_relocation, ventura:        "54f80cd95dd3e9d4b5ada2dd2fc167056e5dfaede228b11e8b2102392b632de7"
    sha256 cellar: :any_skip_relocation, monterey:       "54f80cd95dd3e9d4b5ada2dd2fc167056e5dfaede228b11e8b2102392b632de7"
    sha256 cellar: :any_skip_relocation, big_sur:        "54f80cd95dd3e9d4b5ada2dd2fc167056e5dfaede228b11e8b2102392b632de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c07b0d9fbc02e1eb6df9acd81b60f5a69c36830063dcb014989536d528058a"
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
