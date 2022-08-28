require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.20.tgz"
  sha256 "902e29c77e7d8a837b6704489be5c157ebfd494b7ec80968447951cb87579c3b"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "aaacdb50cc3cbeda27782e0febff06efffd9813bddd40d5f3673575a29e441f3"
    sha256                               arm64_big_sur:  "f7550a966fb7970f6c576ceced1d3ff0d2cb6b9e2f42e6a0c50a049374324992"
    sha256                               monterey:       "8570299f75c26af3e4b16bdb05616fc945d4a4d49913d3b8758a03d55bf056f4"
    sha256                               big_sur:        "4635bf340456e5672de322cc7780f67800cdabd4a278fa93bf2802fef5f03213"
    sha256                               catalina:       "4ae3b6de2981b6a0d03b9623e7ea6c69ea3dd77714bd178211c4c202a7092245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "996dee64bd19a2c0f8ed81de89798f41f8d4d38420eb7afca5eba52466aef184"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
