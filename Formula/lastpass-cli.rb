class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.3.1.tar.gz"
  sha256 "25dc9a0c99a10ee70b5b3991d525448c25f312cc69fa0216d7ac70c4ae384b1b"
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9bd7ee2b2399f57ea9656252451f6d0843f98a8c8b5067a5b5a6e64e3a62cab1" => :mojave
    sha256 "5839bd81ab06a2ba928e206ee625d5b4c63f5ad52f0cd0d3205c7989cb077138" => :high_sierra
    sha256 "6dbb3753199894a941659b6347f6a4d85d3163f6b3718344e69977a780b2018e" => :sierra
    sha256 "038ed9da9bbe031fdfaa50d612b2952c6c2f67fc83ef44da76ef7f447cf14964" => :el_capitan
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
