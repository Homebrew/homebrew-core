class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.0/lastpass-cli-1.6.0.tar.gz"
  sha256 "9d52616fc1065eb7122cd9b43a31c4155eed22c3ef9d2806dbb3cb49e9d38859"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "668ecd05d52f6f783a4731f5c999d3315e85e5534982c2a66574494cb52cb39a"
    sha256 cellar: :any,                 arm64_sonoma:   "ed7d74c933f0027faccadcbf6306381912d6f0d43898a0728619e567e8df5467"
    sha256 cellar: :any,                 arm64_ventura:  "e7feee38ad111909c95ad5da1f3b0574755564aab688ece5f6fe7f250b9f3537"
    sha256 cellar: :any,                 arm64_monterey: "a0fddec6c0c16bbbaf1d3afdd6accda370daebf141dea87290f89a8fba8331e8"
    sha256 cellar: :any,                 sonoma:         "c68a69722cc6a4cb15f250c69f482d8edcfa055877fec4b092c331b398cc9535"
    sha256 cellar: :any,                 ventura:        "75ea985edf8019726ca1fc4a4bf2f548010757d1a903335f3839dbe6b92fa83b"
    sha256 cellar: :any,                 monterey:       "fd4dc9735a358b864591435f1a5a396327076def887f7e619d73efcad6c36934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f18215620449def4005943a5e2708552f13d8eb16a7da57f89a3c3c178e295ae"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
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
