class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.1/lastpass-cli-1.6.1.tar.gz"
  sha256 "5e4ff5c9fef8aa924547c565c44e5b4aa31e63d642873847b8e40ce34558a5e1"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 3
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e547490a82141e4d65e5a86beb319e69e0969a00613ea77562d4d1db33c878a0"
    sha256 cellar: :any,                 arm64_sequoia: "482c55695d8aa4c7c50306e02025282e2946ad725743fe3edae073bcf8268fc4"
    sha256 cellar: :any,                 arm64_sonoma:  "47b6ce505c464f48dfa1f9fb46aeb6cf1545c6d784a0aeb8894414fcebbac780"
    sha256 cellar: :any,                 sonoma:        "0008f85381696f35fd6260696c2b622e588cd6f43e13512156963c3c69b51e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "935451a0d264d9bb0a412f7769ad0c72c2d595ab553e17cfe9d081f1b48f8d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b5d5939c16538205466a3ebf07fd6c9d349825a190699ab9f5954859899dd3"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pinentry"

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
