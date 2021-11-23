class PyenvWhichExt < Formula
  desc "Integrate pyenv and system commands"
  homepage "https://github.com/pyenv/pyenv-which-ext"
  url "https://github.com/pyenv/pyenv-which-ext/archive/v0.0.2.tar.gz"
  sha256 "4098e5a96b048192b0eab66ca5f588602e30ed16aac816e96ff514f6b5896257"
  license "MIT"
  head "https://github.com/pyenv/pyenv-which-ext.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47846141f51863aeda9dbc0578498ec9d550597581a392eeed1d71979156d3f4"
  end

  deprecate! date: "2021-03-18", because: :deprecated_upstream

  depends_on "pyenv"
  uses_from_macos "python" => :test

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin" if OS.linux?
    shell_output("eval \"$(pyenv init -)\" && pyenv which python")
  end
end
