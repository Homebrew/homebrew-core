class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/refs/tags/v1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c219f70ea941a5ba7c779f632de5aa2f19d80fc330ab0edd7eca6beffd62886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd0764b30ca7c0eed88852fbc8bd223cfbc4314255e59cc7f7cceb5e508c60d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "224c99a490aef1e9b24842a83cf954885018e291b323a13de2ce184190df9e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a548dc894e54ba4df4b522e769c1e5f2ca169045a3ac9005e5a4495262ae787"
    sha256 cellar: :any_skip_relocation, ventura:       "01228ad504d5e1e41895ec90fb6aea5dc89bee6eb4097623e797f599dc918907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c74cab2fc6db04c3439c06e4938e669fea04203c67956b4fcabd046f7b231a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c98ef152d8a32a13e5dded91db1efd998925ffffbab5456062d67f358d7394"
  end

  depends_on "python@3.13"

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
    venv = virtualenv_create(libexec, "python3.13")
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
