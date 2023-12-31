class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.25.1/liquibase-4.25.1.tar.gz"
  sha256 "8b2b7aa8ec755d4ee52fa0210cd2a244fd16ed695fc4a72245562950776d2a56"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8535bfaeae6e94cab736fb4632606a157b4e2c67d13cf63220a3f3a5d589031"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8535bfaeae6e94cab736fb4632606a157b4e2c67d13cf63220a3f3a5d589031"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8535bfaeae6e94cab736fb4632606a157b4e2c67d13cf63220a3f3a5d589031"
    sha256 cellar: :any_skip_relocation, sonoma:         "b330f7382949694f6951a35c827ae8d4abbcb0d29d47fc76a66e7ebc58971020"
    sha256 cellar: :any_skip_relocation, ventura:        "b330f7382949694f6951a35c827ae8d4abbcb0d29d47fc76a66e7ebc58971020"
    sha256 cellar: :any_skip_relocation, monterey:       "b330f7382949694f6951a35c827ae8d4abbcb0d29d47fc76a66e7ebc58971020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8535bfaeae6e94cab736fb4632606a157b4e2c67d13cf63220a3f3a5d589031"
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
