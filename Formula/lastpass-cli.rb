class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.3/lastpass-cli-1.3.3.tar.gz"
  sha256 "b94f591627e06c9fed3bc38007b1adc6ea77127e17c7175c85d497096768671b"
  license "GPL-2.0"
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_monterey: "98b073cafd20bdc9379fdd937b3f86729400bbf89e2a10f67145541d7f87089e"
    sha256 cellar: :any,                 arm64_big_sur:  "1bccfb715b94c569d943c9ce5833f74628397abf1311f74c49d6e5d4b25b847b"
    sha256 cellar: :any,                 monterey:       "42a83a59fe0da598dbfb09cde49d4d66845b9137f5ca102cb25f3d8cc01965b8"
    sha256 cellar: :any,                 big_sur:        "10f9224c8bfebae0cf12df72e6144ba3a309956b1efcce574975cd21cec930c5"
    sha256 cellar: :any,                 catalina:       "8643f81d13a40ef8b86efe83fbee1b41b22c492b7725bebab83dcb2d253fd603"
    sha256 cellar: :any,                 mojave:         "f1b7c42dd889f597ef06f0bd72bb1b273c21dc91e5f3e313da8599254954a7ae"
    sha256 cellar: :any,                 high_sierra:    "62629472aafb7e4927d8ab5e9d7189c913e3249a172d0445ffe7eda31b642eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3ea59e2bc30ccd28e1f516be98d1f170fc0fa7ff333938212879d44dfc84477"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  depends_on "curl" if MacOS.version >= :mojave
  depends_on "openssl@1.1"
  depends_on "pinentry"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

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
