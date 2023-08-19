class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.4/lastpass-cli-1.3.4.tar.gz"
  sha256 "f747e42dac3441131f9ebf0c119f27c57e8701968de7718224c2cdeb91300b6b"
  license "GPL-2.0"
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7ac23f12806efea426486ef32453c5294db21ef687039209cbb5e173be167c01"
    sha256 cellar: :any,                 arm64_monterey: "b8573235ac4537fc07bf4baee6e5a148517470647971999dfa85ea30a21c3598"
    sha256 cellar: :any,                 arm64_big_sur:  "805998a4da7a1378b6a5d521eea0adef4160c862a875f8979aae15dfae88eaf1"
    sha256 cellar: :any,                 ventura:        "62a598006aacd066600e3bd38bfb861de8a466fab10a2aea229a1604a69a9bd0"
    sha256 cellar: :any,                 monterey:       "d799322c2791592b32b0bd3e50b842b50ff2a3ecbe8d03671fba3d22eb3e144d"
    sha256 cellar: :any,                 big_sur:        "cbe70d825d5c88d798a1b7a0a7a68c34d6aa3206bb0bd2b813770c4bb336a82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae8de2ae442567021f6ec7aa75aa60121fa9268ceaf479eb30982894f749b516"
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
