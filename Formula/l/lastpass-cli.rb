class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.1/lastpass-cli-1.6.1.tar.gz"
  sha256 "5e4ff5c9fef8aa924547c565c44e5b4aa31e63d642873847b8e40ce34558a5e1"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ef0e66dd2a0206034d4750a932bdf7b3842ad64bf394791cbb7b4de5e0ebfdc"
    sha256 cellar: :any,                 arm64_sonoma:  "b381ad7ecd30a993342cf22f59f91de72a6f9a7006225f2ee76a3c9abb10bc80"
    sha256 cellar: :any,                 arm64_ventura: "c015a4006f07dd1dc19005a042712559699c49a687e251583e2307e1f00a21d2"
    sha256 cellar: :any,                 sonoma:        "a7610f932a5e2cb85bd7aaf671cab2c9ee6e00c6775ae6dc0268e115b77218f4"
    sha256 cellar: :any,                 ventura:       "043a2e2ed36e33158ea8318ee177294c4064151cb053834a4eb4bf00d36420b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d146e7c5eabe5ce158e610cf34a0ba6b853a3afe1e16673d4c785d97223e5f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4503fb1a86f94795f9ccd9433497cde32a9186968873dae16782e53adcb61d79"
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

  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  on_mojave :or_newer do
    depends_on "curl"
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
