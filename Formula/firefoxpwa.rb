class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/FirefoxPWA"
  url "https://github.com/filips123/FirefoxPWA/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e3a18c742cc44d0ffde698753182733da75bfe9a2e331efddeb133c479108328"
  license "MPL-2.0"
  head "https://github.com/filips123/FirefoxPWA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b41b90f0feec4bd3520111a8562a1ebb3c7a5b028834646054d729c281437546"
    sha256 cellar: :any_skip_relocation, big_sur:       "f89de5c0477a2176a74c7724031fe4c514c85adc480b065d917abef4228e7215"
    sha256 cellar: :any_skip_relocation, catalina:      "6a31680b95444147266384d6c66347e9660c3a8f23ed07137c0fa057979be486"
    sha256 cellar: :any_skip_relocation, mojave:        "c95fcd4867072e9141cf306b0e9e494396e79a0d52639fc61a1e85f363f5343e"
  end

  depends_on "rust" => :build

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = bin
    ENV["FFPWA_SYSDATA"] = share
    system "bash", "./packages/brew/configure.sh", version, bin, libexec

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
