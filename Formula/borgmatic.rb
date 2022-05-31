class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https://torsion.org/borgmatic/"
  url "https://files.pythonhosted.org/packages/44/57/9785c3f0a3782a1ab103c1969f8cbd1ed3520b4dee35825492a5463beeb8/borgmatic-1.6.1.tar.gz"
  sha256 "c2261125b2d9de7a2ad2b5889f547266722fb7f04e26b2857cda1d0a3add71e9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a037624c47dd2065aff887a025efe39e284c32d6ee5472b2f774600413ceaaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5c777c3079d4967c4228ef3f0ddaf3d37127ccab0b594ac1f068862fd36f895"
    sha256 cellar: :any_skip_relocation, monterey:       "787c46c2b8552de64a8f3a6cfbacc026dbbef310e897ae595d5affafbbbc2d5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dbfd08265a15de509535315b8ba6add3d952f39bec322eb7f04d5127c7929ab"
    sha256 cellar: :any_skip_relocation, catalina:       "47771a5497ec36ab19debd1769243f45c3b467247031636aab94477780190dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8481567f67866f0fdd5f0dd24ee55ae89bfa122d7890e34d2b5f68a6e2e3c2fc"
  end

  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/9e/62/93a54db0e44c4de57868a7d638d7a8abce113c8bc43a20b10b1109b2a517/jsonschema-4.5.1.tar.gz"
    sha256 "7c6d882619340c3347a1bf7315e147e6d3dae439033ae6383d6acb908c101dfc"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
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
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    borg = (testpath/"borg")
    config_path = testpath/"config.yml"
    repo_path = testpath/"repo"
    log_path = testpath/"borg.log"

    # Create a fake borg executable to log requested commands
    borg.write <<~EOS
      #!/bin/sh
      echo $@ >> #{log_path}

      # Return valid borg version
      if [ "$1" = "--version" ]; then
        echo "borg 1.2.0"
        exit 0
      fi

      # Return error on info so we force an init to occur
      if [ "$1" = "info" ]; then
        exit 2
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
      info --debug #{repo_path}
      init --encryption repokey --debug #{repo_path}
      --version
      prune --keep-daily 7 --prefix {hostname}- #{repo_path}
      compact #{repo_path}
      create #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} /etc /home
      check --prefix {hostname}- #{repo_path}
      --version
      list --json #{repo_path}
    EOS
  end
end
