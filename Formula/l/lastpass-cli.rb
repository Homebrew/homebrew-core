class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.2/lastpass-cli-1.6.2.tar.gz"
  sha256 "b65b9c951a9a17b87b8ac0500808c716ef8e5fe6e70f1fd44f23b8385aa30984"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89bcb64eac7d65b08a6930f0b9102430e2a7547deb608c04ac0f4bcbab3dac59"
    sha256 cellar: :any, arm64_tahoe:       "ddf402721a0dcae43b46d5a94a0722b6f673556a9031b5bc00e5a0ca95e39413"
    sha256 cellar: :any, arm64_sequoia:     "c0d0e46bd160a919974f2f67af9560457f16ec55c4d079cca9dbd439236b78cc"
    sha256 cellar: :any, arm64_linux:       "242591b25182e6385b849f43cae5c8bd19472ec3b6a4d44a4e083dd0be5ee589"
    sha256 cellar: :any, x86_64_linux:      "d0785f605e3ae50255d42516aee40e6a7f535e0d7337df20c436c9911eab1cbf"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "openssl@4"
  depends_on "pinentry"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # Workaround for CMake 4 compatibility
  patch do
    url "https://github.com/lastpass/lastpass-cli/commit/31a4ad5f735933ff8e96403103d5b4f61faee945.patch?full_index=1"
    sha256 "a4c2a16fd47942a511c0ebbce08bee5ffdb0d6141f6c9b60ce397db9e207d8be"
    type :unofficial
    resolves "https://github.com/lastpass/lastpass-cli/pull/716"
  end

  deny_network_access!

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_MANDIR=#{man}", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install", "--target", "install-doc"

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    mkdir testpath/".config/lpass"

    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
