class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.23.2/liquibase-4.23.2.tar.gz"
  sha256 "fc7d2a9fa97d91203d639b664715d40953c6c9155a5225a0ddc4c8079b9a3641"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "226a8619ffe473451938910c432fc1ead545548ff54a700e255e9414cd8f0905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "226a8619ffe473451938910c432fc1ead545548ff54a700e255e9414cd8f0905"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "226a8619ffe473451938910c432fc1ead545548ff54a700e255e9414cd8f0905"
    sha256 cellar: :any_skip_relocation, ventura:        "8c818b9fd7de36af28caaebf88459146a751af8ba7d3bdb82f6a7055e6e1eb33"
    sha256 cellar: :any_skip_relocation, monterey:       "8c818b9fd7de36af28caaebf88459146a751af8ba7d3bdb82f6a7055e6e1eb33"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c818b9fd7de36af28caaebf88459146a751af8ba7d3bdb82f6a7055e6e1eb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226a8619ffe473451938910c432fc1ead545548ff54a700e255e9414cd8f0905"
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
