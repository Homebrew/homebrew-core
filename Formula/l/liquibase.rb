class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.28.0/liquibase-4.28.0.tar.gz"
  sha256 "97dd07eaca0406a09e1ae19b407eea42a7e944c7f4571922bffce71b43b75ce8"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.com/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f656f23a5b73ec555a9b74d1467d0641da686727e3b924884c0d9c37dc108a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3f3d97bd968f720ecd114227cbaa27dc42c0fb1002ebfec1e5116e0e566f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16bfd265f06e98bcdf3534e5b60a37998a653e55d299928f57ca7088ee48d5f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "75b37c2a8bdb8ae22190af082d13a708bb0475af4d639de12be4f3fdbec8cabc"
    sha256 cellar: :any_skip_relocation, ventura:        "625e0ad8ebc740d8462119de5c0ec753f906234a218ddf204da80687490531cb"
    sha256 cellar: :any_skip_relocation, monterey:       "c52e2aa756ad8a17df93e68e56834fae76cf943c77a9c385233df5f388bd4879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c6a6cebe4451eb89812bb2736478c907144cad501f29c70267b66be1d3b301"
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
