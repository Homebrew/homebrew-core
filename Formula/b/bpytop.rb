class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/refs/tags/v1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"
  head "https://github.com/aristocratos/bpytop.git", branch: "master"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b19bca99c4b0dadd6f0acaab677713cb36e69066d938e40975bb6ec5e1e5e0a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5de2cc3e6a468f7de3afc1a4c0e89b6fdc5b015c9948a069163a4cd8f5e883f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68fda2ed5723d9a9dbd8314b432256fea597aed76249e118f5d84f9ad7f3435"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47e3022d6b8328e32736b7193ac9d3c6678567697ad808252db830ce3b634db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c67cef4be215e9374aebee5f4541a7f87b4d3a87dde27c738ce4f9d349ad90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8429d3cbe14ef4215355724446eb5720130c89d596441d7184166f3b4c1f8dd"
  end

  depends_on "python@3.14"

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
    venv = virtualenv_create(libexec, "python3.14")
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
    sleep 15
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
