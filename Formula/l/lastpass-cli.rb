class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.5.0/lastpass-cli-1.5.0.tar.gz"
  sha256 "542dc3d7ff175866c0eddfcc6f2dffdb54acf6854dd1fadaf4d509dcde2d4bf3"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e0e9e93eceb917add96f46595db8779192f3b97fb09e3652e22507448b4f96e"
    sha256 cellar: :any,                 arm64_ventura:  "29a6b3f8d4213ae70f9b139c69b77c4198f29c98969ab4ca0149c01458545c84"
    sha256 cellar: :any,                 arm64_monterey: "7fb41903543bc5ba3e6955618c8cf30aa6b93bcfb73bd214e51eb991beee0fef"
    sha256 cellar: :any,                 sonoma:         "7251f3d6e491146ce84c01690ede3458be53f419e4413bd26d47e2994b55989e"
    sha256 cellar: :any,                 ventura:        "afcd5243540bdf1f55a2e89854884ca0385c1971f35312e074c57f085ca10588"
    sha256 cellar: :any,                 monterey:       "1f2a8fc79da38209ae4240841f93d0e1cbe971f42d1f6333bb7aeb65d3973a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b1f2db3b88a3aa788b06e465c6e605d1e3d21c361a13b1e75e394d13a9c4b7"
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
