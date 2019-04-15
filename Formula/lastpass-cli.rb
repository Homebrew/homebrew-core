class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.3/lastpass-cli-1.3.3.tar.gz"
  sha256 "b94f591627e06c9fed3bc38007b1adc6ea77127e17c7175c85d497096768671b"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "644f34d11c0776baada68ada57ce19e1c2a4ed030b668baa3223821829300e01" => :mojave
    sha256 "95a6d678d7ba3f065f3e45dadee09e359a96a20f572e91b5ff8d8441e97e087e" => :high_sierra
    sha256 "c6db5831f35cfd51c116fddb7ada509fd36a893da36ff4be1d5a2fa4b433ca30" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  depends_on "curl" if MacOS.version >= :mojave
  depends_on "openssl"
  depends_on "pinentry"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_MANDIR:PATH=#{man}"
      system "make", "all", "lpass-test", "test", "install", "install-doc"
    end

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish"
  end

  test do
    system "#{bin}/lpass", "--version"
  end
end
