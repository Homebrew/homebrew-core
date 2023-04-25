class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.21.1/liquibase-4.21.1.tar.gz"
  sha256 "c04542865e5ece8b7b1ee9bd6beaefc5315e350620288d6ac1a2d32c3b1f7d8b"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cef9cc52068e44e05ffcca395937af36a0ea52c12174116dc2bbd7b6664f90a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cef9cc52068e44e05ffcca395937af36a0ea52c12174116dc2bbd7b6664f90a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cef9cc52068e44e05ffcca395937af36a0ea52c12174116dc2bbd7b6664f90a"
    sha256 cellar: :any_skip_relocation, ventura:        "9855ba5b50cb011bde1381f0fcff30b9e8c46a5a1d838896f6f2701aba26b707"
    sha256 cellar: :any_skip_relocation, monterey:       "9855ba5b50cb011bde1381f0fcff30b9e8c46a5a1d838896f6f2701aba26b707"
    sha256 cellar: :any_skip_relocation, big_sur:        "9855ba5b50cb011bde1381f0fcff30b9e8c46a5a1d838896f6f2701aba26b707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cef9cc52068e44e05ffcca395937af36a0ea52c12174116dc2bbd7b6664f90a"
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
