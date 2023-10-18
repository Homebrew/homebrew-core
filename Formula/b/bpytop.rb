class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/v1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7653bbf2d74cc0b616b5f58311f6a964732367764d35bf82651640de534e8ccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a2fe2f58f33fda16a273c4a285a8df43b7105ec68b61e30a957969a78047b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "571a52528cbd3f3a0d05604cf9011caa42fa0d548f33f7743b3922a364b26362"
    sha256 cellar: :any_skip_relocation, sonoma:         "6edef42fa7ff2fc0b9a07289521f4e94f537ff36ea053fc7c7739977df15117c"
    sha256 cellar: :any_skip_relocation, ventura:        "70303f33694f0ebe4ca372a70807a8ac183c6915f3cbc14d2e35ab098d76e95c"
    sha256 cellar: :any_skip_relocation, monterey:       "08d583f8d9944fd437326a636b8ab02c4c150f41009ac2bc453c167fd3945da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07be8a3c2e76de894f88040d89f9b45eac5dffc1256bad0987cfddcb3ba11989"
  end

  depends_on "python@3.12"

  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2d/01/beb7331fc6c8d1c49dd051e3611379bfe379e915c808e1301506027fce9d/psutil-5.9.6.tar.gz"
    sha256 "e4b92ddcd7dd4cdd3f900180ea1e104932c7bce234fb88976e2a3b296441225a"
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

    r, w, pid = PTY.spawn("#{bin}/bpytop")
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
