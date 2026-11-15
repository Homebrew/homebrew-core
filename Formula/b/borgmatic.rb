class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https://torsion.org/borgmatic/"
  url "https://files.pythonhosted.org/packages/d9/6e/76e1bff53c336ad7d5698fa4abf948faf2d820e9f5c2b99917a14268a9a9/borgmatic-2.2.0.tar.gz"
  sha256 "2f3a1e8f697b267e64fac9aaec628e68f89075854807436956c64d3b8542af3b"
  license "GPL-3.0-or-later"
  head "https://projects.torsion.org/borgmatic-collective/borgmatic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4570aaeb28a864c2735b371841f3771a5903a39422739dca39952b6bb57dba5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3afadaa9b150686bbc7e8a782a4dc8a4bdcea708a16c466106081866b18efd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29fca534f765567c710a998e6704577167ee2a3db4beca7b1cd9088c4892eae1"
    sha256 cellar: :any,                 arm64_linux:       "3a7e7954592cd10d81d6fc9db4acaf2da1278bca9247cb6fba3064240d9edaef"
    sha256 cellar: :any,                 x86_64_linux:      "8a6eb7fe0813897a33fd156308bea79112b34571e5fc8b2a2b802d74a574b56e"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
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
    borg.write <<~SH
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
    SH

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
      info --log-json --json #{repo_path}
      init --encryption repokey --debug #{repo_path}
      --version --log-json
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} --dry-run --list
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} --log-json #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f}
      prune --keep-daily 7 --glob-archives {hostname}-* --log-json #{repo_path}
      compact --log-json #{repo_path}
      info --log-json --json #{repo_path}
      check --glob-archives {hostname}-* --log-json #{repo_path}
      --version --log-json
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} --dry-run --list
      create --patterns-from #{testpath}/borgmatic-.{8}/borgmatic/tmp.{8} --log-json --json #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f}
      prune --keep-daily 7 --glob-archives {hostname}-* --log-json #{repo_path}
      compact --log-json #{repo_path}
      info --log-json --json #{repo_path}
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
