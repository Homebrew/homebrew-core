class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.14.0/liquibase-4.14.0.tar.gz"
  sha256 "e21064c8e82b77c4d033c1600d8b7daa186ab3e8a516deb546a5cd1102f548dd"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.org/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83f2d552b1b9ae1325992a86f0786c1c5a8492cf40dc8cc1048e2e6574d6e06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c83f2d552b1b9ae1325992a86f0786c1c5a8492cf40dc8cc1048e2e6574d6e06"
    sha256 cellar: :any_skip_relocation, monterey:       "07ab22e5b11cb23bc6652377e32563d3628996dcea362b4fbcf67c2ed4a65a62"
    sha256 cellar: :any_skip_relocation, big_sur:        "07ab22e5b11cb23bc6652377e32563d3628996dcea362b4fbcf67c2ed4a65a62"
    sha256 cellar: :any_skip_relocation, catalina:       "07ab22e5b11cb23bc6652377e32563d3628996dcea362b4fbcf67c2ed4a65a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c83f2d552b1b9ae1325992a86f0786c1c5a8492cf40dc8cc1048e2e6574d6e06"
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
