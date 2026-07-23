class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https://torsion.org/borgmatic/"
  url "https://files.pythonhosted.org/packages/00/20/4f28c29b14876bee6438d8dd698b80f9188cad066258b8068e3f40676a4e/borgmatic-2.1.6.tar.gz"
  sha256 "320c7c3e719f4dae63ebee774559ed3c76b91032406363500b77ef9b2463db86"
  license "GPL-3.0-or-later"
  head "https://projects.torsion.org/borgmatic-collective/borgmatic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c312444da81d043316febdc6a224da60cc16061b5fda85d65afc0bceba19881c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/b9/28/99c51f664567218d824af024c0251650fb27e4ca066df188dab0769c5b91/idna-3.17.tar.gz"
    sha256 "5eb0cb53bc467c12eadcf6de83163ad8527cec9416f44b9b61b19caedad2b87f"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["TMPDIR"] = testpath

    borg = (testpath/"borg")
    borg_info_json = (testpath/"borg_info_json")
    config_path = testpath/"config.yml"
    repo_path = testpath/"repo"
    log_path = testpath/"borg.log"
    sentinel_path = testpath/"init_done"

    # Create a fake borg info json
    borg_info_json.write <<~JSON
      {
          "cache": {
              "path": "",
              "stats": {
                  "total_chunks": 0,
                  "total_csize": 0,
                  "total_size": 0,
                  "total_unique_chunks": 0,
                  "unique_csize": 0,
                  "unique_size": 0
              }
          },
          "encryption": {
              "mode": "repokey-blake2"
          },
          "repository": {
              "id": "0000000000000000000000000000000000000000000000000000000000000000",
              "last_modified": "2022-01-01T00:00:00.000000",
              "location": "#{repo_path}"
          },
          "security_dir": ""
      }
    JSON

    # Create a fake borg executable to log requested commands
    borg.write <<~SHELL
      #!/bin/sh
      echo $@ >> #{log_path}

      # return valid borg version
      if [ "$1" = "--version" ]; then
        echo "borg 1.2.0"
        exit 0
      fi

      # for first invocation only, return an error so init is called
      if [ "$1" = "info" ]; then
        if [ -f #{sentinel_path} ]; then
          # return fake repository info
          cat #{borg_info_json}
          exit 0
        else
          touch #{sentinel_path}
          exit 2
        fi
      fi

      # skip actual backup creation
      if [ "$1" = "create" ]; then
        exit 0
      fi
    SHELL

    borg.chmod 0755

    # Generate a config
    config_path.write <<~YAML
      source_directories:
          - /home
          - /etc
      repositories:
          - path: #{repo_path}
      local_path: #{borg}
      patterns:
          - R #{testpath}
          - '- #{config_path}'
      keep_daily: 7
    YAML

    # Initialize Repo
    system bin/"borgmatic", "-v", "2", "--config", config_path, "init", "--encryption", "repokey"

    # Create a backup
    system bin/"borgmatic", "--config", config_path

    # See if backup was created
    system bin/"borgmatic", "--config", config_path, "--json"

    # Read in stored log
    log_content = File.read(log_path)

    # Assert that the proper borg commands were executed
    expected_log = <<~EOS
      --version --log-json --debug --show-rc
      info --critical --log-json --json #{repo_path}
      init --encryption repokey --debug #{repo_path}
      --version --log-json
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} --dry-run --list
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} --log-json #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f}
      prune --keep-daily 7 --glob-archives {hostname}-* --log-json #{repo_path}
      compact --log-json #{repo_path}
      info --critical --log-json --json #{repo_path}
      check --glob-archives {hostname}-* --log-json #{repo_path}
      --version --log-json
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} --dry-run --list
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} --log-json --json #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f}
      prune --keep-daily 7 --glob-archives {hostname}-* --log-json #{repo_path}
      compact --log-json #{repo_path}
      info --critical --log-json --json #{repo_path}
    EOS
    expected = expected_log.split("\n").map(&:strip)

    log_content.lines.map.with_index do |line, i|
      if line.start_with?("create")
        assert_match(/#{expected[i].chomp}/, line.chomp)
      else
        assert_equal expected[i].chomp, line.chomp
      end
    end
  end
end
