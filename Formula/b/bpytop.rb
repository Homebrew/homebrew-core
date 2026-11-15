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
    rebuild 7
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00cb4c1b77641395ada449f1954fd7fef0fafec953f57718c4a4de581ce5a9d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed3b3902a8c0082d56296be270fb11c764018d810f1cc930e29366697e02f3ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc5641928ce45eb2198dac79fc9c8a559e6041c4f43401b3d6127ba98a2737f0"
    sha256 cellar: :any,                 arm64_linux:       "9d087d3d7c6cd6f0d7895baed3c26c76f8a16d8b9b315b4493bdd5ffb9c27070"
    sha256 cellar: :any,                 x86_64_linux:      "e5c2fa1e7c99d34c0000207b7d95b3607bdbcc61a294c402f50a2724c5c0c492"
  end

  depends_on "python@3.15"

  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  # Tolerate SMC error from osx-cpu-temp
  patch do
    url "https://github.com/aristocratos/bpytop/commit/5634526721b1bc98dc7a7003801cdf99686419ed.patch?full_index=1"
    sha256 "0158252936cfd1adcbe5e664f641a0c2bb6093270bedf4282cf5c7ff49a7d238"
    type :unofficial
    resolves "https://github.com/aristocratos/bpytop/pull/405"
  end

  def install
    venv = virtualenv_create(libexec, python3)
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
