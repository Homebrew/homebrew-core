class Pgtune < Formula
  desc "Tuning wizard for postgresql.conf"
  homepage "https://github.com/gregs1104/pgtune"
  url "https://ftp.postgresql.org/pub/projects/pgFoundry/pgtune/pgtune/0.9.3/pgtune-0.9.3.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/pgtune/pgtune/0.9.3/pgtune-0.9.3.tar.gz"
  sha256 "31ac5774766dd9793d8d2d3681d1edb45760897c8eda3afc48b8d59350dee0ea"
  license "BSD-3-Clause"

  # 0.9.3 does not have settings for PostgreSQL 9.x, but the trunk does
  head "https://github.com/gregs1104/pgtune.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99d46ab0880d22bb3a19faf759bde25d51dd0e4c5c1890d6bf0e253a9042e09f"
  end

  # pgtune is for postgresql 8.x and 9.x, and is no longer maintained.
  deprecate! date: "2024-08-03", because: :unmaintained
  disable! date: "2025-08-03", because: :unmaintained

  def install
    # By default, pgtune searches for settings in the directory
    # where the script is being run from.
    inreplace "pgtune" do |s|
      s.sub!(/(parser\.add_option\('-S'.*default=).*,/, "\\1\"#{pkgshare}\",")
    end
    bin.install "pgtune"
    pkgshare.install Dir["pg_settings*"]
  end

  test do
    system bin/"pgtune", "--help"
  end
end
