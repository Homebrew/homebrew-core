class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.1/lastpass-cli-1.6.1.tar.gz"
  sha256 "5e4ff5c9fef8aa924547c565c44e5b4aa31e63d642873847b8e40ce34558a5e1"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93b96dc3bb80345c74934995e2e4899bad889abf98fefec321707ef216d787cd"
    sha256 cellar: :any,                 arm64_sequoia: "840a351d5bd7022e7c60f2cc9c47b65bacd9b1cfb4314d604b7a5b9ee119c273"
    sha256 cellar: :any,                 arm64_sonoma:  "76fcf9be8c41da58c8f15255048f4a755579655d8eaeccc84b5ac05a96c9d9e0"
    sha256 cellar: :any,                 sonoma:        "09a1378f0bc30b4718a8a2752c75be049cf6ca5cdf105fd6a0307e26656fe149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ab592522ad509c596a81bc676aaaf6e19bfed68672037d42637f293d69c9918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604fa7938c619c42ddb92b76c410f1d9fd2d16b156befc61cc36ad1121fe243f"
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
  # PR ref: https://github.com/lastpass/lastpass-cli/pull/716
  patch do
    url "https://github.com/lastpass/lastpass-cli/commit/95fff9accc5832264e31af3f54f49af461339693.patc>
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
