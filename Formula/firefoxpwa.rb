class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "c99c66d80597f8f5160bcd802e65fd16b9156710549b2867013e591f1277eeb6"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e98efbfa3db43a7ba404e29e5054d3a96665c870d3f6689d6b97b4b4e620ea00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c43a3871a4ea3f300034006c3c4df1c5316aed1b94658b221ef3bbed3766910d"
    sha256 cellar: :any_skip_relocation, monterey:       "b27fd00be26d56f6ce0b9a9d7137a7e048c67fa928b0042c85b8f6407a522538"
    sha256 cellar: :any_skip_relocation, big_sur:        "c63e2e96e87fdf77bed3bdf5d416ff23a3a2c04a6f9bb2b9a5dd27227e48f33d"
    sha256 cellar: :any_skip_relocation, catalina:       "dd12066c735dea55c2ee2a8750e292758b9746942cb88b85a96e6158872d8239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a4faf70def07dc66371259b4f8caffd2ee77cbb9a3c86a7bfceb23d181b6de"
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
