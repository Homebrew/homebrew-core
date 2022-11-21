class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "ceec8d6a40fef5de29a23abe00ce3e7fa78d14ebc6954ca4e4b733b2c785b7d7"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "359cb3c82cb976dd86c40e1e4e9415b8cb9eb5f51a6a930fec833e9bb1d4b0a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6da6c0d7ac79b23d6fd4c8eabc70b1ebff38b2a53394ef630f9f5e409160e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3b5b6f4b0169aa56c29fa2bd5530839d1cc59ec31057bcb0b935d7929a38a5b"
    sha256 cellar: :any_skip_relocation, ventura:        "940a28a931397ae72918bcaef38c5683a588f81faa68b8cbda0e9229dbfd1337"
    sha256 cellar: :any_skip_relocation, monterey:       "9a147b672accc91ab54a5623aa891a6c5c68294fe650dac3cde5bb758b89426e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bb0707690fe8e5cdc0e413a87ecc3a4deba5adfd1638f2d1cbd3abffe789719"
    sha256 cellar: :any_skip_relocation, catalina:       "7742304538d9e72dc5003b2f6964699ddbfe251c3389f070ce46f3e45f6e3a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462ca8a6e3338a334da4a2b31c681939d06aed0704a87c71714b80ae5f659c83"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
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
