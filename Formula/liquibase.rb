class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.20.0/liquibase-4.20.0.tar.gz"
  sha256 "cd1b5004d1d9c19f367eb973443204e85938e25e39a1ccf3860046d720874626"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "787b476e27b2a238817121097cf63db452ab0b2fa78ae20aa6cae856073f0510"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "787b476e27b2a238817121097cf63db452ab0b2fa78ae20aa6cae856073f0510"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "787b476e27b2a238817121097cf63db452ab0b2fa78ae20aa6cae856073f0510"
    sha256 cellar: :any_skip_relocation, ventura:        "a8ae2d89cd0378214579efe8dcfa25d7da3d215cd14874b707de781e576d21ed"
    sha256 cellar: :any_skip_relocation, monterey:       "a8ae2d89cd0378214579efe8dcfa25d7da3d215cd14874b707de781e576d21ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8ae2d89cd0378214579efe8dcfa25d7da3d215cd14874b707de781e576d21ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787b476e27b2a238817121097cf63db452ab0b2fa78ae20aa6cae856073f0510"
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
