class Bashly < Formula
  desc "Bash command-line framework and CLI generator"
  homepage "https://bashly.dev"
  url "https://github.com/bashly-framework/bashly/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "952d4c49e7c55c967a05701075b44d31edbafda23098aabc93d235f3aae92110"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "05e59758ed36f5e127e1d43ff80d417f16ff9db6543a8e6912f95e8919b4cc24"
    sha256 cellar: :any, arm64_tahoe:       "5a474247920f82e0ad014cd4658bebdf6b0d10da3efe3c64428d6a0f9d01adb1"
    sha256 cellar: :any, arm64_sequoia:     "137c334c11161df0ea0298628fe29868aca7fb284b038d92821972cf8f5bb460"
    sha256 cellar: :any, arm64_linux:       "3ac4978372cee2d7803f383840117e24f087c1aa113770553fe5724c5c6873ad"
    sha256 cellar: :any, x86_64_linux:      "1f4438ca4f6a917fa116c937b2894a5dc95f9729a5075a7cd08830c6649736cc"
  end

  depends_on "ruby"

  uses_from_macos "libffi"

  on_macos do
    depends_on "bash"
  end

  resource "colsole" do
    url "https://rubygems.org/downloads/colsole-1.0.1.gem"
    sha256 "7632a300ace2db877c024ffe413c684954cf37e41264b75ace9f456c9d657b02"
  end

  resource "docopt_ng" do
    url "https://rubygems.org/downloads/docopt_ng-0.7.1.gem"
    sha256 "a024148ee4fa3ab1a8a04411aa4370f39cf2b446e63562097d418b7974a15667"
  end

  resource "erb" do
    url "https://rubygems.org/downloads/erb-6.0.7.gem"
    sha256 "c5ca6dc25b0ef974a44dc8f59fe847577122483b1968a38dec305c60bf91ee92"
  end

  resource "gtx" do
    url "https://rubygems.org/downloads/gtx-0.1.2.gem"
    sha256 "668b14cc9a0a0f4103f2cc5c4e9acdfd05401691bf9fbea9e74f6f5018b6f3ba"
  end

  resource "io-console" do
    url "https://rubygems.org/downloads/io-console-0.9.4.gem"
    sha256 "a403304f32928ee85e56d457b4612ca43f2703b561a3258844992bd24085fbb1"
  end

  resource "kramdown" do
    url "https://rubygems.org/downloads/kramdown-2.5.2.gem"
    sha256 "1ba542204c66b6f9111ff00dcc26075b95b220b07f2905d8261740c82f7f02fa"
  end

  resource "mister_bin" do
    url "https://rubygems.org/downloads/mister_bin-0.9.0.gem"
    sha256 "624fe401db4faf1978e84c17e0b320827697a13a6cba4fe656001269079be7d3"
  end

  resource "pastel" do
    url "https://rubygems.org/downloads/pastel-0.8.0.gem"
    sha256 "481da9fb7d2f6e6b1a08faf11fa10363172dc40fd47848f096ae21209f805a75"
  end

  resource "reline" do
    url "https://rubygems.org/downloads/reline-0.7.0.gem"
    sha256 "5b012d8e55dbf9d450f12bde2cf7d15ff546ae80b3f8f3b30e570d431815583d"
  end

  resource "requires" do
    url "https://rubygems.org/downloads/requires-1.1.0.gem"
    sha256 "575a506a6b77361a8a763fc6c6448690207e45d5ef0ab99523b439696e5f9136"
  end

  resource "rexml" do
    url "https://rubygems.org/downloads/rexml-3.4.4.gem"
    sha256 "19e0a2c3425dfbf2d4fc1189747bdb2f849b6c5e74180401b15734bc97b5d142"
  end

  resource "rouge" do
    url "https://rubygems.org/downloads/rouge-4.7.0.gem"
    sha256 "dba5896715c0325c362e895460a6d350803dbf6427454f49a47500f3193ea739"
  end

  resource "strings" do
    url "https://rubygems.org/downloads/strings-0.2.1.gem"
    sha256 "933293b3c95cf85b81eb44b3cf673e3087661ba739bbadfeadf442083158d6fb"
  end

  resource "strings-ansi" do
    url "https://rubygems.org/downloads/strings-ansi-0.2.0.gem"
    sha256 "90262d760ea4a94cc2ae8d58205277a343409c288cbe7c29416b1826bd511c88"
  end

  resource "tty-color" do
    url "https://rubygems.org/downloads/tty-color-0.6.0.gem"
    sha256 "6f9c37ca3a4e2367fb2e6d09722762647d6f455c111f05b59f35730eeb24332a"
  end

  resource "tty-markdown" do
    url "https://rubygems.org/downloads/tty-markdown-0.7.2.gem"
    sha256 "1ed81db97028d006ba81e2cfd9fe0a04b0eb28650ad0d4086ed6e5627f4ac511"
  end

  resource "tty-screen" do
    url "https://rubygems.org/downloads/tty-screen-0.8.2.gem"
    sha256 "c090652115beae764336c28802d633f204fb84da93c6a968aa5d8e319e819b50"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/downloads/unicode-display_width-2.6.0.gem"
    sha256 "12279874bba6d5e4d2728cef814b19197dbb10d7a7837a869bab65da943b7f5a"
  end

  resource "unicode_utils" do
    url "https://rubygems.org/downloads/unicode_utils-1.4.0.gem"
    sha256 "b922d0cf2313b6b7136ada6645ce7154ffc86418ca07d53b058efe9eb72f2a40"
  end

  resource "watchly" do
    url "https://rubygems.org/downloads/watchly-0.2.0.gem"
    sha256 "eb9dd449bc8a703325162f293308b5bd5403741f8c91e7ca14802b0eaaa8d067"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |resource|
      system "gem", "install", resource.cached_download,
        "--ignore-dependencies", "--install-dir", libexec, "--no-document"
    end

    system "gem", "build", "bashly.gemspec"
    system "gem", "install", "--ignore-dependencies", "bashly-#{version}.gem",
      "--install-dir", libexec, "--no-document"

    rm libexec.glob("extensions/*/*/*/mkmf.log")

    (bin/"bashly").write_env_script libexec/"bin/bashly", GEM_HOME: ENV.fetch("GEM_HOME")
    generate_completions_from_executable(
      bin/"bashly",
      "completions",
      shell_parameter_format: :none,
      shells:                 [:bash],
    )
  end

  test do
    system bin/"bashly", "init", "--minimal"
    system bin/"bashly", "generate"
    assert_path_exists testpath/"download"
    system testpath/"download", "--help"
  end
end
