class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "6a8a4c4fc8dcd3e6f6b7fc0214bf4ac5d471beacb326e6b9a1ea68e70c0d9750"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e0ea789851f2824a3aeadd4cb7d4d7c2d8c0035b9991a09ef3f91d1fdb94fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672f0c0babcdc24ecc0e8752068a1dfd0f84a85fb0f884b08c3def435daaa27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6322f46c872f7eeaa7c644d0879a25b3cd60793d4b8c78fdeef2bb67d6f9c66c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4846cc895aa392dafdaab085440bc40bbe40930d1d9c3934fd5c4a4f84e0704d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bbeeef45e5bb57d0dc9bd57272197a938ec4c7fe326ba3061a1dd1fb7a4942c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c84dd45c806015855abcf90ef8eac209707940f3b5eef2bc7f6d47560f6a33fa"
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
