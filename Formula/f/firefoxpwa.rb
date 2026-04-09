class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "a6956631ba62442d108cddfd8139d69d39f47004e8d36390a042ab8580d08021"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b6b9242665adc6a44a2da0dbe17f926b7ce8226fadf71fe0b1dc51af4ce4349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dacc0bfd9f6abe22991e60443dfc60cf6dc16d06dda1dcc9499ca14eecd7266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423a273b3a6790cfdc9c0e871f9c931a492ec679824263e659cd8b26358a9a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3aee9faf6712ebfa4be77443228e2b428749bc854fedd2fb380fca4452b95e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03b4f7d82c1c97eac6cb742419c6ecb8d0efb82b44b4d8f23c635d96660159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ae69012de7e629ff5e8413ba71525ff56615d7bfb05715eb493753db2ad466"
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
