class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https://torsion.org/borgmatic/"
  url "https://files.pythonhosted.org/packages/ff/6a/436b4b3a3f38f62261bf4a7e106c01096f36092a968880ee91686206b60e/borgmatic-1.7.4.tar.gz"
  sha256 "b1b1e46252e12f42c17a0984c40ace10fc22d52806f0d687f2d0a1a99869a007"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16bcd4891083cc41ded92d07141ac56a231b885bb484160183937cd5f2360bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "519355fd42c87addf6b5749c25f5918d410dee31d973d69b64920bb616eddbf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8a67afe44dc2b59ff3efb754bbe670a7bc530cb1c37607e7c8148cf31cd1e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "796a43261f07c224ee9fcea36032c7df379e1c19b9297725f5217f5e684b5a9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5949cf08995b52d94f5f7461a37d974b60b2a34e4da03d4b7d6ca07fa756f162"
    sha256 cellar: :any_skip_relocation, catalina:       "e0130f22becee542b612bc004ec0282063c02e0f9e2d25e5cddcdc1da4fa3dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ffe1de21c272458b76ed9877c2ddbff08d4b454fd55884eace5e6784c4e7be7"
  end

  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/65/9a/1951e3ed40115622dedc8b28949d636ee1ec69e210a52547a126cd4724e6/jsonschema-4.17.1.tar.gz"
    sha256 "05b2d22c83640cde0b7e0aa329ca7754fbd98ea66ad8ae24aa61328dfe057fa3"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    borg = (testpath/"borg")
    borg_info_json = (testpath/"borg_info_json")
    config_path = testpath/"config.yml"
    repo_path = testpath/"repo"
    log_path = testpath/"borg.log"
    sentinel_path = testpath/"init_done"

    # Create a fake borg info json
    borg_info_json.write <<~EOS
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
    EOS

    # Create a fake borg executable to log requested commands
    borg.write <<~EOS
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
    EOS
    borg.chmod 0755

    # Generate a config
    system bin/"generate-borgmatic-config", "--destination", config_path

    # Replace defaults values
    inreplace config_path do |s|
      s.gsub!(/# ?local_path: borg1/, "local_path: #{borg}")
      s.gsub! "- ssh://user@backupserver/./sourcehostname.borg", "- #{repo_path}"
      s.gsub! "- ssh://user@backupserver/./{fqdn}", ""
      s.gsub! "- /var/local/backups/local.borg", ""
      s.gsub! "- /var/log/syslog*", ""
      s.gsub! "- /home/user/path with spaces", ""
    end

    # Initialize Repo
    system bin/"borgmatic", "-v", "2", "--config", config_path, "init", "--encryption", "repokey"

    # Create a backup
    system bin/"borgmatic", "--config", config_path

    # See if backup was created
    system bin/"borgmatic", "--config", config_path, "--list", "--json"

    # Read in stored log
    log_content = File.read(log_path)

    # Assert that the proper borg commands were executed
    assert_match <<~EOS, log_content
      --version --debug --show-rc
      info --json #{repo_path}
      init --encryption repokey --debug #{repo_path}
      --version
      prune --keep-daily 7 --glob-archives {hostname}-* #{repo_path}
      compact #{repo_path}
      create #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} /etc /home
      info --json #{repo_path}
      check --glob-archives {hostname}-* #{repo_path}
      --version
    EOS
  end
end
