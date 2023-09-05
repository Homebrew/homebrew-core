class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.6/lastpass-cli-1.3.6.tar.gz"
  sha256 "4e6f9a5df9fab46cb6192f40762933faba002479d9387eecbd5ffb28efb9d88b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ba4c25a685bc918cbc8bf54e3703561fce1e18593390900e82132131482f8c17"
    sha256 cellar: :any,                 arm64_monterey: "141ea2506d8322b7b6b163b09b5397be739dfaabc7912bb4dec8694da4c0154f"
    sha256 cellar: :any,                 arm64_big_sur:  "3f123f151600a5eafaec998486f504c9d80e29082d0dd1a7ebcf0118d5c857b7"
    sha256 cellar: :any,                 ventura:        "88739e816bbbdeff9d098da1ea8fdfe88514ef2850e924862abb0749f5f07281"
    sha256 cellar: :any,                 monterey:       "0f7261cc2dc48aee5528cd66989ec452f5c9779190d34b519c8e69a6e0edcc50"
    sha256 cellar: :any,                 big_sur:        "6993c808909e7c40bf1653a38419d2aafe2c73e8064ffc62959899a11e5e5064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d51b7a153a156629e7d69b24ed1bc856ac75eb206847e12ad59b5ffeae676e4"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pinentry"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  on_mojave :or_newer do
    depends_on "curl"
  end

  # Newer GCC compatibility patch, https://github.com/lastpass/lastpass-cli/pull/609
  patch do
    on_linux do
      url "https://github.com/lastpass/lastpass-cli/commit/23595c38c4f522c8a33bc75ba93d7fdb27040880.patch?full_index=1"
      sha256 "d2e5c22319c4533e44658564052ea1f849530e158e34ecc430a08e138959292f"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_MANDIR:PATH=#{man}"
      system "make", "install", "install-doc"
    end

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
