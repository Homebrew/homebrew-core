class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d2aff50d963d9d197b41f8736d9fbc3a01922f455d7b90eae1ce80dab3d9f313"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "482605deb9373590c1cdeec5c59655d91496c655dc72aea51e0c3ec80b0d3ea7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0bf80ae08375deceeb809e52df42a35579a9f2783ddfbcd1002fcc96b1fd696"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b6930db257ea8d0186d357bbdda4a0f3bd26836cc0ff8519cf5e19b69b271d"
    sha256 cellar: :any_skip_relocation, sonoma:         "45711a5cb25fc3d24d9b09e010735f66e39749393fde1b3b08a62abddd378c57"
    sha256 cellar: :any_skip_relocation, ventura:        "6b56958960fe1af6907503abc394cccd30c9e01471ebf3c528c97ea90fb38a28"
    sha256 cellar: :any_skip_relocation, monterey:       "31241dbf6ca3fffec4c0b87807f6751ff386ff76147e2e048d91d4ebf228b078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa357d1c61b02a886a158c9e2955d04fde66e69e8cfb6f2bc13aaa78ef46b34c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version.to_s, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
