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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edb971b0d93ae1c3a7887d7e3b9aa00421a8b9b5e31f90b9e3dde197dafd287a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb971b0d93ae1c3a7887d7e3b9aa00421a8b9b5e31f90b9e3dde197dafd287a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb971b0d93ae1c3a7887d7e3b9aa00421a8b9b5e31f90b9e3dde197dafd287a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d4c18d97e7dfc7a22642c7c089ad92bda22c7c7da9c25b2b7800157f80c558a"
    sha256 cellar: :any_skip_relocation, ventura:        "1d4c18d97e7dfc7a22642c7c089ad92bda22c7c7da9c25b2b7800157f80c558a"
    sha256 cellar: :any_skip_relocation, monterey:       "1d4c18d97e7dfc7a22642c7c089ad92bda22c7c7da9c25b2b7800157f80c558a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb971b0d93ae1c3a7887d7e3b9aa00421a8b9b5e31f90b9e3dde197dafd287a"
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
