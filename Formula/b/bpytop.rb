class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/refs/tags/v1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afbf743207adc75d2e3892ce97f745e488d10cf684c3403cb2bf8ca380413143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd9246bfdd892cc310121f01b98ad28affb17a62e85fc9739a2b5d80be8f20b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d37cdbe668836efa2cad572810831e376cfbb7e3aa5cd1d47591806a6fb077"
    sha256 cellar: :any_skip_relocation, sonoma:         "6adb154d1352cc284cfe07dc2a4832e56d702a065253c35955a89eded824fe18"
    sha256 cellar: :any_skip_relocation, ventura:        "3f1faa82258730cb0c6408b4906ecf5c48c0e11129c59bcf971fa5c394f5fd3a"
    sha256 cellar: :any_skip_relocation, monterey:       "620f4bc5466211bea4b3bcd363f5a97a15ed6081d7d12fc8cb4998f54e36f392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f053d1d4872dfbe70e7a432ffd4d80c0254369887ef65182673ac4e73ed16f0"
  end

  depends_on "python@3.12"

  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  # Tolerate SMC error from osx-cpu-temp
  # https://github.com/aristocratos/bpytop/pull/405
  patch do
    url "https://github.com/aristocratos/bpytop/commit/5634526721b1bc98dc7a7003801cdf99686419ed.patch?full_index=1"
    sha256 "0158252936cfd1adcbe5e664f641a0c2bb6093270bedf4282cf5c7ff49a7d238"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "themes"

    # Replace shebang with virtualenv python
    rw_info = python_shebang_rewrite_info("#{libexec}/bin/python")
    rewrite_shebang rw_info, bin/"bpytop"
  end

  test do
    config = (testpath/".config/bpytop")
    mkdir config/"themes"
    # Disable cpu_freq on arm due to missing support: https://github.com/giampaolo/psutil/issues/1892
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
      show_cpu_freq=#{!Hardware::CPU.arm?}
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn(bin/"bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
