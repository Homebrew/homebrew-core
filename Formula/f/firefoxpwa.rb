class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "97ee2e61698f79629871b7eeca1d70c32ccfc68a49902b9ecd6da05b142bfe19"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26649dd862ec0fd836b5b5c36ac7c88b83a3cc4e88b9654d0abc2815a2e18e67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d7e5034022ced004d696de2a89dab3c989ad075eb40e39480ab447a7b15dfc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a93df3bbb4d58673ee11fc9a1fc7b401d82c8513e15edc8284ddee4aa8bfe92"
    sha256 cellar: :any,                 arm64_linux:       "4747caffa8cbf607cc5f94f17e80b044b30c1fd360e37c524c4ac4e8a1c07509"
    sha256 cellar: :any,                 x86_64_linux:      "2597537067a34dcc50510a4ce7879c14080119423f4f7ecca8552eaf5e2b8967"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    cd "native" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
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
