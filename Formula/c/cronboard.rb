class Cronboard < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based dashboard for managing cron jobs locally and on servers"
  homepage "https://cronboard.dev/"
  url "https://github.com/antoniorodr/cronboard/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "56e2a5dc3e4994ab701eeed4339b9c1790bfab9e9f019d27d4f5669fc988cd5a"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "da6ad4eec8b03e3692857e833658d145b1dfd7349e9cf512de170cdfc7b1a547"
    sha256 cellar: :any, arm64_golden_gate: "a4bfeb4812502bfe96de82f34ceb4a1ca7a163f070289c3f21c2d13cdc094ea9"
    sha256 cellar: :any, arm64_tahoe:       "bebd7cfad0d6f7b67741efb392f67a06eb457ec436053b3e71833023363531df"
    sha256 cellar: :any, arm64_sequoia:     "2478ffcff72ec81c886313088bf2922c488838b100cbd47838290c3a0ea74505"
    sha256 cellar: :any, arm64_linux:       "7dd32c6e98e922de5946427d2fc59fd586aadeaf065a467ffe29486b62c074b0"
    sha256 cellar: :any, x86_64_linux:      "0e3149851c1686a610548805f8234cf358cd562fb9c2f216deee2ff92096249d"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "cryptography"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "cron-descriptor" do
    url "https://files.pythonhosted.org/packages/b9/89/f8910574c6153a808bb70ca4975c8d5c9f5e3d9782a93d0bfef1053763c5/cron_descriptor-2.3.5.tar.gz"
    sha256 "63fe96544d8a7fe6d6e655b87abc3cbac9e76fd404fb9834c3fc2696d2e665fd"
  end

  resource "croniter" do
    url "https://files.pythonhosted.org/packages/54/17/3c60d4cf8c8768f8a116328f94ddb2f205e64d5afbb1bcb85f315bfbbf42/croniter-7.0.0.tar.gz"
    sha256 "a0b2568303c774f6a4ea2d4ce2e72b1ee911029c7070d64a1befe05cdb107f5a"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/ad/a4/77a4e1be19fd9b08993c76d5e54979ac836b327754f1f5fecfed1b56cc67/mdit_py_plugins-0.7.0.tar.gz"
    sha256 "26d2179227aaf4d1dc7acffe7a738cbd15cade6b5a61cff0a2cbf9fed93efede"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/76/cb/b1fde76618d84b1acf54d3d03d2b833ba5878afd12b9899346cc080f209d/paramiko-5.1.0.tar.gz"
    sha256 "239b5f9b2a53006cd54f83cf8495ee742083708ead947882c8dd2786de79f39b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "python-crontab" do
    url "https://files.pythonhosted.org/packages/49/3e/f61917a63b20d0ce0dfb58e44192201892a1cfe9d4167264b93fa5485594/python_crontab-3.4.0.tar.gz"
    sha256 "d2b5ad91f7a641d774661b7f3ba52258fd68273862c88713f4cc092ba614e707"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/1e/3a/80411bc7b94969eb116ad1b18db90f8dce8a1de441278c4a81fee55a27ca/textual_autocomplete-4.0.6.tar.gz"
    sha256 "2ba2f0d767be4480ecacb3e4b130cf07340e033c3500fc424fed9125d27a4586"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Stub `crontab` so the TUI starts regardless of whether the host has cron
    (testpath/"bin/crontab").write <<~SH
      #!/bin/sh
      exit 0
    SH
    (testpath/"bin/crontab").chmod 0755
    ENV.prepend_path "PATH", testpath/"bin"

    require "expect"
    require "io/console"
    require "pty"

    PTY.spawn(bin/"cronboard") do |r, w, pid|
      r.winsize = [24, 80]
      r.set_encoding("UTF-8")
      refute_nil r.expect("v#{version}", 30), "expected the cronboard banner"
      w.write "\x03"
    ensure
      Process.kill "KILL", pid
      # Drain the pty so the killed TUI can finish exiting and be reaped
      begin
        r.read(nil, +"")
      rescue Errno::EIO
        nil
      end
      Process.wait pid
    end
  end
end
