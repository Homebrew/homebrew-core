class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "c9510cc0222e5a3b66451a8ac558205a3a63f24df78c4ddef5d5313a553aa521"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "122b66a24fa72f7bcc40489d93f9021ab957e7bf590ce7f5fdfb3d166b00846e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b629b8c527c862d5731ab320c15d23063aa684bd587a933ef23afa9b5d22bb9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7dc6439cd3da8ccb8e65ba75746bc6f21c9da9c27a1d91aed548f370f4374dc"
    sha256 cellar: :any_skip_relocation, ventura:        "6fdbf79aa744fa9aaaefa23227bcd5e7ce4f0ce1e1f3275761c0b427af46b371"
    sha256 cellar: :any_skip_relocation, monterey:       "9d1bf860e5ca1417fb1909bf59ecf76694dc042ae08f1b1a856cfe103a224d26"
    sha256 cellar: :any_skip_relocation, big_sur:        "037baf810a23d65a8687b06e54d0da902cf6cf1455bbbd6c217e13479115f156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca2c8fe61e5a2da8cdbf3d68269a9727599f7d9a81f7429fd054a16e895a2471"
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
    system "bash", "./packages/brew/configure.sh", version, opt_bin, opt_libexec

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
    # Test version so we know if Homebrew configure script correctly sets it
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
