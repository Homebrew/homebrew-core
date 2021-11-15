class Offlineimap < Formula
  desc "Synchronizes emails between two repositories"
  homepage "https://www.offlineimap.org/"
  url "https://files.pythonhosted.org/packages/09/12/73db8d38fea8ec3536cbccb8286b46b426639aff7e166840fa5e68e889e2/offlineimap-7.3.4.tar.gz"
  sha256 "5dbd7167b8729d87caa50bed63562868b6634b888348d9bc088a721530c82fef"
  license "GPL-2.0-or-later"
  head "https://github.com/OfflineIMAP/offlineimap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e00518eec9664acc605e89da1bbc7c23e790ebef87e48982a2fbc58aa4985467"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddd56697d3c6e9caf9ce43cb18b4c8c5e2b71dda041363be7b3f02487700edd0"
    sha256 cellar: :any_skip_relocation, monterey:       "21516cf410d1551232395e78afda6cfff1bffb393e961dbafe2c31e5384262e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "022f1f1fb23f151854e050d510398d0c156d71fdb718ac32c5f7061152732b92"
    sha256 cellar: :any_skip_relocation, catalina:       "022f1f1fb23f151854e050d510398d0c156d71fdb718ac32c5f7061152732b92"
    sha256 cellar: :any_skip_relocation, mojave:         "8bad1b2782ecd2d85bb388c616d57ad98f10886384711dbf36447269d076f0d9"
  end

  depends_on :macos # Due to Python 2 (Will never support Python 3)
  # https://github.com/OfflineIMAP/offlineimap/issues/616#issuecomment-491003691
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/58/a8/1dfba2db1f744657065562386069e547eefea9432d3f520d4af5b5fabd28/rfc6555-0.0.0.tar.gz"
    sha256 "191cbba0315b53654155321e56a93466f42cd0a474b4f341df4d03264dcb5217"
  end

  resource "selectors2" do
    url "https://files.pythonhosted.org/packages/86/72/27ccb21c1ff9fa87e1ba45e38045722b4eff345ba61760224793560638f4/selectors2-2.0.2.tar.gz"
    sha256 "1f1bbaac203a23fbc851dc1b5a6e92c50698cc8cefa5873eb5b89eef53d1d82b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    ENV.delete("PYTHONPATH")
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Remove hardcoded python2 that does not exist on high-sierra or mojave
    inreplace "Makefile", "python2", "python"
    inreplace "bin/offlineimap", "python2", "python"

    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
    libexec.install "bin/offlineimap" => "offlineimap.py"
    libexec.install "offlineimap"
    (bin/"offlineimap").write_env_script(libexec/"offlineimap.py",
      PYTHONPATH: ENV["PYTHONPATH"])
  end

  def caveats
    <<~EOS
      To get started, copy one of these configurations to ~/.offlineimaprc:
      * minimal configuration:
          cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

      * advanced configuration:
          cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
    EOS
  end

  service do
    run [opt_bin/"offlinemap", "-q", "-u", "basic"]
    run_type :interval
    interval 300
    environment_variables PATH: std_service_path_env
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"offlineimap", "--version"
  end
end
