class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.7/lastpass-cli-1.3.7.tar.gz"
  sha256 "448a53960602164456bbc9156d017540a1dac989a8cab7bc6a2a9781b52d47cb"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "177e2d87a9c1d179486a0d45e8204003239d854ecc4c23ca803dd08cc3278cce"
    sha256 cellar: :any,                 arm64_ventura:  "1ae5e09672e1850485f83452599f7804b23d3733d24c69ae90bc58e5024f25bd"
    sha256 cellar: :any,                 arm64_monterey: "b60409de408e4b86dbe7c4a8a0fcc7b40f5784d762967daa1f8671398882e682"
    sha256 cellar: :any,                 sonoma:         "ac76e8a2f4c13959161f1d029cbbaad28d8916352e7fb482e29d1d0c5e66731c"
    sha256 cellar: :any,                 ventura:        "c5af272e2b934e1525b69b6861bbe6cc0f38e39783ab3adc77fbd61c68dab2a0"
    sha256 cellar: :any,                 monterey:       "11048aff621bc79a0912f0487b531cdbe7bd8398ccbb9e8d22bac81421a37993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff94855f3e97861d4e55e501220a39a23649570a274f6ada6a10d8a4e8df8b97"
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
