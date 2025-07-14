class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.33.0/liquibase-4.33.0.tar.gz"
  sha256 "689acfcdc97bad0d4c150d1efab9c851e251b398cb3d6326f75e8aafe40ed578"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3cdb5d8dd61a55e73793b4ac48e75c198d9ec82fd07290e7215855aa2f89f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3cdb5d8dd61a55e73793b4ac48e75c198d9ec82fd07290e7215855aa2f89f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e3cdb5d8dd61a55e73793b4ac48e75c198d9ec82fd07290e7215855aa2f89f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7694432ffb6cd54bb60b52ba39b5bcaec8c1a82e966576ec73691509a770878f"
    sha256 cellar: :any_skip_relocation, ventura:       "7694432ffb6cd54bb60b52ba39b5bcaec8c1a82e966576ec73691509a770878f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3cdb5d8dd61a55e73793b4ac48e75c198d9ec82fd07290e7215855aa2f89f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3cdb5d8dd61a55e73793b4ac48e75c198d9ec82fd07290e7215855aa2f89f2"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])

    chmod 0755, "liquibase"
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
    system bin/"liquibase", "--version"
  end
end
