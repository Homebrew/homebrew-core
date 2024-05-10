class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.4.0/lastpass-cli-1.4.0.tar.gz"
  sha256 "e317c7ac964e35d8535e039b70c0eab26fe4ef5aa596ad0f09f72fd8c7207d87"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0db1bba3298820fc8026e8413fd551d84f7ea2f5e1c0e5d4503a0d6dea032ee"
    sha256 cellar: :any,                 arm64_ventura:  "d5a911fb612b47c20b240730d634e336d05b7a3485e77c50d81daf13e5883851"
    sha256 cellar: :any,                 arm64_monterey: "f2f003ecc5842f784a0332b69ffdcaff03471de08ca2a145adb0a125afdb5e55"
    sha256 cellar: :any,                 sonoma:         "f9b65123d0e03d7caefdc85603c4fe6cdb74d2efc5d46fe2a47746cde5b240e3"
    sha256 cellar: :any,                 ventura:        "c92cbd3e13a1f702bc683dcc8ee60088520606849d0bb99f25a16e52ba161c27"
    sha256 cellar: :any,                 monterey:       "960580a653f746bede884a676ee1d898a50e7a2b10093af482ae4a578c1bcb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93a9e53234c6bfc4f1bc79a2adc372d0347038fc749b60ebed9cf565cbb4c8c0"
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
