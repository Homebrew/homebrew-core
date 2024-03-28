class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.27.0/liquibase-4.27.0.tar.gz"
  sha256 "50d89e1fc10249bf198f1a8ff2d81fd0b68e6ca0805db28a94d38649784d82f0"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2c3a070f0c481323ec824ad1e8adfbf55a26ad1da5b4e8e44b872718ba2bbfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2c3a070f0c481323ec824ad1e8adfbf55a26ad1da5b4e8e44b872718ba2bbfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c3a070f0c481323ec824ad1e8adfbf55a26ad1da5b4e8e44b872718ba2bbfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c73888c4128174716d1cc686cce880f0ce09cd383b1baee31455b247e6231d29"
    sha256 cellar: :any_skip_relocation, ventura:        "c73888c4128174716d1cc686cce880f0ce09cd383b1baee31455b247e6231d29"
    sha256 cellar: :any_skip_relocation, monterey:       "c73888c4128174716d1cc686cce880f0ce09cd383b1baee31455b247e6231d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2c3a070f0c481323ec824ad1e8adfbf55a26ad1da5b4e8e44b872718ba2bbfb"
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
