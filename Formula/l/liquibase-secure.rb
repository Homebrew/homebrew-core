class LiquibaseSecure < Formula
  desc "Database change management tool (Secure)"
  homepage "https://www.liquibase.com/"
  url "https://package.liquibase.com/downloads/secure/homebrew/liquibase-secure-5.0.0.tar.gz"
  sha256 "689acfcdc97bad0d4c150d1efab9c851e251b398cb3d6326f75e8aafe40ed578"
  license "Apache-2.0"

  livecheck do
    url "https://package.liquibase.com/downloads/secure/homebrew/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)\/?"/i)
  end

  no_autobump! because: :requires_manual_review

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])

    chmod 0755, "liquibase"
    libexec.install Dir["*"]
    bash_completion.install libexec/"lib/liquibase_autocomplete.sh" => "liquibase"
    zsh_completion.install libexec/"lib/liquibase_autocomplete.zsh" => "_liquibase"
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
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
