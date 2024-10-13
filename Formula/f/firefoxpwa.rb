class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.12.5.tar.gz"
  sha256 "97f6efb5a43a3fe32f09b0ae7b8669f755d6df7f7bff531f3cd64b392358a4d8"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3acbfecd45ed77fc7ee0d2d83580d55a6f4f2d348875e56ac02a3c988baf2a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6692edb02883ff5b5d9a145a86b40a26a809ac2232697d24b2bd44e019d7e453"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfebfaa7b56d9404635d987d165b48570bf76e838eae19e696c319a02dd8bc7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "148323853aa436a98d57b7e28ce875cd261faefb3b153789587bd10e026c3af2"
    sha256 cellar: :any_skip_relocation, ventura:       "4d968253e00d2dbd6255f49081f8a2d2c4b0eb7731173bbc0408c9f8060ff258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "656bfe7eb59e7b74dee7ac8dcbc8e1ae5ee72eaf9ae5f932c05a02eeb92f1d0e"
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
