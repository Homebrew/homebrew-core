class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.18.4.tar.gz"
  sha256 "905fbe651ba5eebe7fc98b91dbd471e6202e78725ed288359a7a7ed81a1a56ae"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba685923626e35a6f0eba99242979bedacc59cedb47a01273965376aea4bf81b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce84a2a203b787a00d46bf922337c9a098d5d8d869fde3ed7559d49f9ce2310e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600d6df94fa4170f01e133041b616833bfd17faaa7e051278a8c971bcd52a7fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "531fcbd3278ace84ac373f711e95e18f9e15816a8b06f8176cb83102ed68fe6b"
    sha256 cellar: :any,                 arm64_linux:   "550c91d2d46b5f366af576fe8d2f244d71d45481f0b3ec98fb0af3d4c53e9f96"
    sha256 cellar: :any,                 x86_64_linux:  "70163fcde0880f238a7ee1af7913905a4a2edec408a8f4505a1f8d38f0eea4cd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
