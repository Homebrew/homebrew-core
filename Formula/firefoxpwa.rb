class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "ceec8d6a40fef5de29a23abe00ce3e7fa78d14ebc6954ca4e4b733b2c785b7d7"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4cd3bec32221077cf2ff6324334722afdc5257160270c674e6be0f2f6cc36a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23ae248dc1a083f1c88ad5ad18e5e35b7d86db1836ebada6071bd7c46a8ba0e1"
    sha256 cellar: :any_skip_relocation, monterey:       "0f643c2a1e77bb8bf6722536b6e0634366077af76e51a93f9ae300fb5f9a22c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "599e0f843e4c5d3e5d96d602e41e1d8cab3fdd55ab40fa0449cbbe600f05a2be"
    sha256 cellar: :any_skip_relocation, catalina:       "821fa7f9bc5b09cf397dcf216e674d766041b08f20906e0b616b07b9d20458c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52a0b66323905d51bab5bb4c0e7d01401cb605c7212007739eebbca32c3823e"
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
