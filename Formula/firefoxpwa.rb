class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/FirefoxPWA"
  url "https://github.com/filips123/FirefoxPWA/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "47cb03a8f5773da235e360655a4ef93203d7d3ed760ebf6013692ec20239c2c1"
  license "MPL-2.0"
  head "https://github.com/filips123/FirefoxPWA.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34bde79a2cbafaedf07c7e8934146ffba5e1e67a4c274c4e2f3ff0201e1917c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c14a9904573549af2671f3eb32b490fa18c42605c86f4ac07256bd56c742fca"
    sha256 cellar: :any_skip_relocation, catalina:      "b5b49d08ef4c23e877dd93d9116f5a15128343953bbd2a62f30986a5ae8c5f66"
    sha256 cellar: :any_skip_relocation, mojave:        "3a0f52cd72431ec43f842c66bc63a1ac6de21ed2671518074a9eea74301cd870"
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
        sudo mkdir -p #{destination}
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
