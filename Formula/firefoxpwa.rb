class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "c9510cc0222e5a3b66451a8ac558205a3a63f24df78c4ddef5d5313a553aa521"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "943f5a20162768f4cd6d0b72f50a7dc29b019e01b9969be19b5eafaa11106beb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f81a56fb46a357efe933c38fe283b7f92f0a2ff2d6a6a97cfe294da719fa275"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1723995f9d48dbfb0d23b24082b8dae2e31edb24ea4fb2d4b3aa1e582405e337"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac2ed6441a496c14800f73887e5b1f2a9f8a1aa59767e722d45d9dd6ba045e1"
    sha256 cellar: :any_skip_relocation, monterey:       "821167011f36e646d101eb6c71beeadeff912bfa4f85c4d2005eca54422fc0a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ee48f48b09ac4e02e4291f62ef7b3883bb4fa1f6785eacbadcdc9036450fc17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199fb984f7c98d0f5fd33cd4eedb6c57c45371ab8d3fb145bf41f097e6a2ef69"
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
