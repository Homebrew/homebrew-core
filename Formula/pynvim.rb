class Pynvim < Formula
  include Language::Python::Virtualenv
  desc "Python client and plugin host for Nvim"
  homepage "https://pynvim.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/7a/01/2d0898ba6cefbe2736283ee3155cba1c602de641ca5667ac55a0e4857276/pynvim-0.4.3.tar.gz"
  sha256 "3a795378bde5e8092fbeb3a1a99be9c613d2685542f1db0e5c6fd467eed56dff"
  license "Apache-2.0"
  head "https://github.com/neovim/pynvim.git", branch: "master"

  depends_on "neovim"
  depends_on "python@3.9"

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end
  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/72/7e/d8586068d47adba73afc085249712bd266cd7ffbf27d8bc260c33e9d6133/greenlet-1.1.1.tar.gz"
    sha256 "c0f22774cd8294078bdf7392ac73cf00bfa1e5e0ed644bd064fdabc5f2a2f481"
  end
  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    virtualenv_install_with_resources
  end

  test do
    system libexec/"bin/python3", "-c", <<~EOS
      import pynvim
      import json
      import os
      child_argv = os.environ.get('NVIM_CHILD_ARGV')
      listen_address = os.environ.get('NVIM_LISTEN_ADDRESS')
      child_argv = '["nvim", "-u", "NONE", "--embed", "--headless"]'
      editor = pynvim.attach('child', argv=json.loads(child_argv))
      assert editor != None
      assert listen_address is None or listen_address != ''
      assert 'remote' == editor.api.get_chan_info(editor.channel_id)['client']['type']
    EOS
  end
end
