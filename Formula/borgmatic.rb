class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https://torsion.org/borgmatic/"
  url "https://files.pythonhosted.org/packages/07/76/ff953d01e2852aee43c3ffc2df44d6386125819f41b9d834b295752eaf3d/borgmatic-1.6.6.tar.gz"
  sha256 "cbb95c0a19a8da1796af25bf09ed9158005b6c72be18790db43d2bffda2fa32b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5c2fb89a82f019c695d077af46656e61a70d8b1966682abd5503e819653746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21d37d330313aa69bd89813db9bddce5202a5494f971af4744a2ea47ab1ebe34"
    sha256 cellar: :any_skip_relocation, monterey:       "cdfdbfed93cdc660e399480d8fd5d2c9967df2baf086fe82320346f28f52001b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8772ac93711d2893c6e9f7b5c76277a449f999296b1b4b196698f72a2c2381d5"
    sha256 cellar: :any_skip_relocation, catalina:       "091f93b96240e8af4b5ad9d9b35be22c3b2a1dcad0bd8c6165e5c3f069a80d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a352000e6aab3959e3ee4d72e469cf03c160b678a0f370457e8e8c550dbe2ddd"
  end

  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/19/0f/89db7764dfb59fc1c2b18c2d63f11375b4827aa3e93ae037166a780d2bed/jsonschema-4.7.2.tar.gz"
    sha256 "73764f461d61eb97a057c929368610a134d1d1fffd858acfe88864ee94f1f1d3"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
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
    config_content = File.read(config_path)
                         .gsub(/# ?local_path: borg1/, "local_path: #{borg}")
                         .gsub(/user@backupserver:sourcehostname.borg/, repo_path)
                         .gsub("- user@backupserver:{fqdn}", "")
                         .gsub("- /var/log/syslog*", "")
                         .gsub("- /home/user/path with spaces", "")
    File.open(config_path, "w") { |file| file.puts config_content }

    # Initialize Repo
    system bin/"borgmatic", "-v", "2", "--config", config_path, "--init", "--encryption", "repokey"

    # Create a backup
    system bin/"borgmatic", "--config", config_path

    # See if backup was created
    system bin/"borgmatic", "--config", config_path, "--list", "--json"

    # Read in stored log
    log_content = File.read(log_path)

    # Assert that the proper borg commands were executed
    assert_equal <<~EOS, log_content
      --version --debug --show-rc
      info --json #{repo_path}
      init --encryption repokey --debug #{repo_path}
      --version
      prune --keep-daily 7 --prefix {hostname}- #{repo_path}
      compact #{repo_path}
      create #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} /etc /home
      info --json #{repo_path}
      check --prefix {hostname}- #{repo_path}
      --version
      list --json #{repo_path}
    EOS
  end
end
