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
    rebuild 3
    sha256 "b612b3711fb8ee5808f78c7f5dc06de7085287ee0159a0c6c2e8eb25b4221db9" => :big_sur
    sha256 "4c908256d426b3f1aecd95b5c9ae5acaa2c8ff327891c1254d30b149c5997752" => :catalina
    sha256 "8bb9debd4a15ed5c49486469a63db77128890d272a4665418af562bd4fdb6a23" => :mojave
    sha256 "ce6281beed7e1a0d8733240001f60f58b5d28737e6de4ad8c7f8264594f78c7f" => :high_sierra
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
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
