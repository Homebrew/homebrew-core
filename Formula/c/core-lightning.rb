class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  stable do
    url "https://github.com/ElementsProject/lightning/releases/download/v26.06.9/clightning-v26.06.9.zip"
    sha256 "ac37b1b6c41b6c60cf06dd8cd7500f1fab04411cf2f3bc126838d8cafab4538d"

    patch do
      url "https://github.com/ElementsProject/lightning/commit/d384750883216e7e19e01779d06bc36295380296.patch?full_index=1"
      sha256 "4f5c972865a57de11a420e319584710f821e68c908d861e40ed5b741b0bffa6e"
      type :backport
      resolves "https://github.com/ElementsProject/lightning/pull/9072"
    end
  end

  # Upstream releases may have an embargo period between when the release is
  # published and the source zip is provided, so we have to check multiple
  # releases to identify the newest one providing a source archive.
  livecheck do
    url :stable
    regex(%r{/v?(\d+(?:\.\d+)+)/clightning[._-]v?\d+(?:\.\d+)+\.zip}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  bottle do
    sha256 arm64_golden_gate: "ee50592a25e36387eca12934badc43ed5dc56ffa14b39e3ea83ec5f620b5fe92"
    sha256 arm64_tahoe:       "9e0a711f1124eb2587a69be1671b2a8326f78a7ffdf9138312c73e0d1be0109a"
    sha256 arm64_sequoia:     "8c23947e4dbc55bb84cb7cd202ecd76a9a0acfe0973236b6ff01ceac9e239aa4"
    sha256 arm64_linux:       "be7d8b86a3e792f80a9bf8902371d5969d22b7d649bd57ff6bdad2a61966e2f8"
    sha256 x86_64_linux:      "a4044c0d0e0fef694876a8582a082c3b341a07375f7ad4aafa506bd03d7fce81"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "uv" => :build
  depends_on "bitcoin"
  depends_on "libsodium"
  depends_on "sqlite"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["mako", "setuptools"]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    rm_r Dir["#{bin}/*.dSYM"]
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
