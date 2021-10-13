class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/FirefoxPWA"
  url "https://github.com/filips123/FirefoxPWA/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "7785ae80a58c38c0ef88d3b6943f1202c8fbad69f848f57216e97e4dd75ba1c7"
  license "MPL-2.0"
  head "https://github.com/filips123/FirefoxPWA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15cdc571c2e1203613ce6dcf750cf4f5ade14fa2c1b6606c147ef3a78d03707c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c02e8de6687d5002f4b356f79ac2b3545924ff39ef092d120daccc2424e555c0"
    sha256 cellar: :any_skip_relocation, catalina:      "e582f5b8900bc7fed7fd8c76bb8dee1bea7282527057cad18f5401bdf29a04da"
    sha256 cellar: :any_skip_relocation, mojave:        "1ee44407c99209a858f78a4a39bd322a8aff5fe3784e11836742ccd1bf89424b"
  end

  depends_on "rust" => :build

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
    assert_includes output, "Site does not exist"
  end
end
