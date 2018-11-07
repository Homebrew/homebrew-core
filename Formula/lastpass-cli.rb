class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.3.1.tar.gz"
  sha256 "25dc9a0c99a10ee70b5b3991d525448c25f312cc69fa0216d7ac70c4ae384b1b"
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    sha256 "b6867561b8ba2c646b2c15037837db58d8085721d4d918ede963c30f95812818" => :mojave
    sha256 "20ea8f49e0be8c5f0ebdfcc3d0cd368cecf2a1d1fe4e4aa5b4e0a93bb9881d57" => :high_sierra
    sha256 "9c2c97113d8f5d9787c25a289c48301f6b8d46275f9b27e1847ef516cb3ad1b2" => :sierra
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
