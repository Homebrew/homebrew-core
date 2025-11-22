class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.1/lastpass-cli-1.6.1.tar.gz"
  sha256 "5e4ff5c9fef8aa924547c565c44e5b4aa31e63d642873847b8e40ce34558a5e1"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 2
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2a5f02a4ca98532c55385ebacc3539000fa5c6b5a4682f3e5cd5124ff1d6cff"
    sha256 cellar: :any,                 arm64_sequoia: "569c58eb35aeb7992dc6fe294bc12ffb9080a583bc84d135ddd93bab2d3995ec"
    sha256 cellar: :any,                 arm64_sonoma:  "e13a16eda126d0829f53904319b45663deb23d226af8ec7906e82a66bfc7d5ca"
    sha256 cellar: :any,                 sonoma:        "e23cb4d80dee3fa976237e1df4305538652531ab1a9d1b13d22d583c330b7898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce94668af616a6b2f3ef80f465e1da9e4537998e2ff886e1a0f1b4b06dd6502d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e72da4920d9db53e2c8cc5b4fd99c2ba72c55dce8721e90fac8657c777ebb58"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "pinentry"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # Workaround for CMake 4 compatibility
  # PR ref: https://github.com/lastpass/lastpass-cli/pull/716
  patch do
    url "https://github.com/lastpass/lastpass-cli/commit/31a4ad5f735933ff8e96403103d5b4f61faee945.patch?full_index=1"
    sha256 "a4c2a16fd47942a511c0ebbce08bee5ffdb0d6141f6c9b60ce397db9e207d8be"
  end

  # Workaround for for API change in OpenSSL 3.5
  # PR ref: https://github.com/lastpass/lastpass-cli/pull/718
  patch do
    url "https://github.com/lastpass/lastpass-cli/commit/95fff9accc5832264e31af3f54f49af461339693.patch?full_index=1"
    sha256 "5d7559511b1814c6f9d8cccc02b7c5dbf8a4e6d2927a94cf76d090cc45a47dd2"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_MANDIR=#{man}", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install", "--target", "install-doc"

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
