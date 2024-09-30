class PostgresqlLatest < Formula
  desc "Meta formula to install the latest PostgreSQL"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v17.0/postgresql-17.0.tar.bz2.md5"
  version "17"
  sha256 "dfac71e09758290b7ca9aa358c67e47dc455b79681824e0ce26c32cdcabb3138"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+)(?:\.\d+)+/?["' >]}i)
  end

  # TODO: conflicts_with "postgresql@14", because: "both install the same binaries"

  depends_on "postgresql@16" => :test
  depends_on "postgresql@17"

  def postgresql
    deps.find { |dep| !dep.test? && dep.name.start_with?("postgresql@") }.to_formula
  end

  def install
    odie "Version does not match `#{postgresql.name}` dependency!" if postgresql.version.major != version.major

    postgresql_versions = [version.major.to_s] + postgresql.versioned_formulae.map { |f| f.version.major.to_s }
    postgresql.opt_bin.each_child do |cmd|
      next unless cmd.file?

      variable_cmd = cmd.sub(postgresql.name, "postgresql@${PG_VERSION}")
      (bin/cmd.basename).write <<~EOS
        #!/bin/bash
        export PG_VERSION="${PG_VERSION:-#{version.major}}"
        case "${PG_VERSION}" in
          #{postgresql_versions.join("|")})
            ;;
          *)
            echo "Invalid version ${PG_VERSION} specified in PG_VERSION" >&2
            exit 1
            ;;
        esac
        if [[ ! -f "#{variable_cmd}" ]]
        then
          echo "postgresql@${PG_VERSION} is either not installed or doesn't provide #{cmd.basename}" >&2
          exit 1
        fi
        exec "#{variable_cmd}" "$@"
      EOS
    end

    postgresql.opt_share.glob("man/man*").each do |mandir|
      next unless mandir.directory?

      (man/mandir.basename).install_symlink mandir.children.select(&:file?)
    end
  end

  def caveats
    prev_version = version.major.to_i - 1
    s = <<~EOS
      Most users should prefer installing a specific PostgreSQL formula like `#{postgresql.name}`
      as PostgreSQL data files need to be manually upgraded on every major version upgrade.
      Do not create any issues about PostgreSQL upgrades on Homebrew's GitHub repositories.

      The installed commands default to `#{postgresql.name}` but can be overriden by using the
      PG_VERSION environment variable, e.g. #{Utils::Shell.export_value("PG_VERSION", prev_version.to_s)}
    EOS
    if version.major > 17
      s += <<~EOS

        If you were previously running `postgresql@#{prev_version}`, then you will need to run
        `pg_upgrade` to migrate your data for continued use with the installed commands.
      EOS
    end
    s
  end

  test do
    pg_config = bin/"pg_config"
    old_postgresql = deps.find { |dep| dep.test? && dep.name.start_with?("postgresql@") }.to_formula
    old_postgresql_version = old_postgresql.version.major.to_s

    assert_equal "#{HOMEBREW_PREFIX}/lib/#{postgresql.name}", shell_output("#{pg_config} --libdir").chomp
    assert_match(/^PostgreSQL #{version.major}\./, shell_output("#{pg_config} --version"))

    with_env(PG_VERSION: old_postgresql_version) do
      assert_match(/^PostgreSQL #{old_postgresql_version}\./, shell_output("#{pg_config} --version"))
    end

    with_env(PG_VERSION: "..") do
      assert_equal "Invalid version .. specified in PG_VERSION", shell_output("#{pg_config} --version 2>&1", 1).chomp
    end
  end
end
