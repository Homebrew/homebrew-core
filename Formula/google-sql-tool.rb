class GoogleSqlTool < Formula
  desc "Command-line tool for executing common SQL statements"
  homepage "https://cloud.google.com/sql/docs/mysql-client"
  url "https://dl.google.com/cloudsql/tools/google_sql_tool.zip"
  version "r10"
  sha256 "b7e993edab12da32772bfa90c13999df728f06792757c496140d729d230b03c3"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8a2db726882c0e8ce9a5dec8c040e9a6fbc66217a969cf4cede54df93f3c76b"
  end

  depends_on "openjdk"

  def install
    # Patch script to find jar
    chmod 0755, "google_sql.sh"
    inreplace "google_sql.sh", 'SQL_SH_DIR="$(cd $(dirname $0); pwd)"',
                               "SQL_SH_DIR=\"#{libexec}\""

    libexec.install %w[google_sql.sh google_sql.jar]
    (bin/"google_sql").write_env_script libexec/"google_sql.sh", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "Release 10", shell_output("#{bin}/google_sql --version")
  end
end
