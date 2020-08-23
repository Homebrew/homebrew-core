class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.3/lastpass-cli-1.3.3.tar.gz"
  sha256 "b94f591627e06c9fed3bc38007b1adc6ea77127e17c7175c85d497096768671b"
  license "GPL-2.0"
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3739dcc590577eaeaecf182f3d6b354173f4dbda632a3b34b7fb35c16831b65c" => :catalina
    sha256 "2edb88e5308ec6f93a5c23d4cf85263a65fe5cde36e9d2c9c524441c6917ac6f" => :mojave
    sha256 "ccd3658c9ae5b54e1c9584971de3c47fbe399a3032c3db878317c1b853d7f22a" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  depends_on "curl" if MacOS.version >= :mojave
  depends_on "openssl@1.1"
  depends_on "pinentry"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_MANDIR:PATH=#{man}"
      system "make", "install", "install-doc"
    end

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish"
  end

  test do
    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
