class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https://torsion.org/borgmatic/"
  url "https://files.pythonhosted.org/packages/58/c7/8d75eac3887ac8571063d78faade3d18bed122d3a5d3fe067890f67e6565/borgmatic-1.5.15.tar.gz"
  sha256 "a9c9857bc9c1b3aa4a5b6c2d55e511acfdad9457a958a6de695402d5bb3ca74e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a29956cf400d77ad6381da7d599bba960c11352794e1e03a2cbdf61c6857ff46"
    sha256 cellar: :any_skip_relocation, big_sur:       "7bb1a14bb3ea3fbc14fa072e51ca52521fac5ff949faeab111af55ee33fc8201"
    sha256 cellar: :any_skip_relocation, catalina:      "3e1e9652345ad5b66f466e10dedbeb65af617fc606cdab4a632763a947dae594"
    sha256 cellar: :any_skip_relocation, mojave:        "2d17b29840168864e552838c28ec6b95a425529b4f0e05cd34c535e74644a317"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/ea/7f/4bcd7276603b4324ac12839a949b3e58f03cda1d87218c89a8a1efe31c1a/ruamel.yaml-0.17.9.tar.gz"
    sha256 "374373b4743aee9f6d9f40bea600fe020a7ac7ae36b838b4a6a93f72b584a14c"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
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
      info --debug #{repo_path}
      init --encryption repokey --debug #{repo_path}
      prune --keep-daily 7 --prefix {hostname}- #{repo_path}
      create #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} /etc /home
      check --prefix {hostname}- #{repo_path}
      list --json #{repo_path}
    EOS
  end
end
