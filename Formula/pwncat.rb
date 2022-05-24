class Pwncat < Formula
  include Language::Python::Virtualenv

  desc "Netcat with FW/IDS/IPS evasion, self-inject-, bind- and reverse shell"
  homepage "https://pwncat.org"
  url "https://files.pythonhosted.org/packages/c9/ce/51f7b53a8ee3b4afe4350577ee92f416f32b9b166f0d84b480fec1717a42/pwncat-0.1.2.tar.gz"
  sha256 "c7f879df3a58bae153b730848a88b0e324c8b7f8c6daa146e67cf45a6c736088"
  license "MIT"
  head "https://github.com/cytopia/pwncat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1d3c17981bbba3ef5b35b162c38d2db2ab802c76fd979956bda9e6880d6a7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa1d3c17981bbba3ef5b35b162c38d2db2ab802c76fd979956bda9e6880d6a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3f4cb5954da1b5a7fccec4bb40f8807548cf79984b701788f72e364222d1fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb3f4cb5954da1b5a7fccec4bb40f8807548cf79984b701788f72e364222d1fe"
    sha256 cellar: :any_skip_relocation, catalina:       "fb3f4cb5954da1b5a7fccec4bb40f8807548cf79984b701788f72e364222d1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5bf7b976619100c3cf8763b48aba07b1c5c52e00230c23aeed1ec249fada17"
  end

  depends_on "python@3.10"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    virtualenv_install_with_resources
  end

  test do
    system "echo HEAD  | #{bin}/pwncat www.google.com 80 | grep ^HTTP"
  end
end
