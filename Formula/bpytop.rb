class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/v1.0.67.tar.gz"
  sha256 "e3f0267bd40a58016b5ac81ed6424f1c8d953b33a537546b22dd1a2b01b07a97"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "302be18ca15e6b772a1537c906a0571015ac9147d6d9be981877831faed125c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d29bed4df3651ba795552146d0082d3e7ed6f0e08ff913bd25a40d0666367fa"
    sha256 cellar: :any_skip_relocation, monterey:       "065b5739a23c2157ff3682f15fbb7e4a9653d8eea68128eadc12f806bd4a4e57"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9124b39222c6cad1fc9f9d55c193f1ba34e26611cb1d9cb82b01834e6008643"
    sha256 cellar: :any_skip_relocation, catalina:       "6c53a6e4e1beffda773d8f98c8ffe1f971d5a2edf90bf91b6f93db4491e61f26"
    sha256 cellar: :any_skip_relocation, mojave:         "ba84fab69b931ddb11536521357b40c669ddc1d562d414cb524bcd11251c6fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ef5047c7a8082a5fe12a5aaf24d410fd9eb8e7bd1c01aa807cbf488d86a4cf"
  end

  depends_on "python@3.10"
  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
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
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
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
