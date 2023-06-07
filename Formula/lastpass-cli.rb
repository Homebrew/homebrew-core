class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.4/lastpass-cli-1.3.4.tar.gz"
  sha256 "f747e42dac3441131f9ebf0c119f27c57e8701968de7718224c2cdeb91300b6b"
  license "GPL-2.0"
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "375f1f7e47d4d33e32137299fcce5f5b68cfb36711cea0fbeb3bb6f45f3480ba"
    sha256 cellar: :any,                 arm64_monterey: "8a18df80d3a670514706bd72dbcf9ade3680fec22ba6312d24e06429d17dc8dc"
    sha256 cellar: :any,                 arm64_big_sur:  "52a2cfb919d4968f5febfaff2a2cd61f8d10ad139fc2431b5a40aa5f33eb33c8"
    sha256 cellar: :any,                 ventura:        "7ef6373cdf1f099c460b9b172be68e83e779b3067a2f28131235c50972e0bdc3"
    sha256 cellar: :any,                 monterey:       "ba841c177acb121be4df49bd5b78e27dd43220649ee86de0f28f68a388e159e7"
    sha256 cellar: :any,                 big_sur:        "ee7e7927b27803925f34d583e27a4336d48e6ebcb04f146feae4acca740bd2e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93cf9d864ec32300a1c886bb460e72fa8b2c0f38f0f737855b09384f4d01fcb"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
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
