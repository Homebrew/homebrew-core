class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "f7c2b05b7891a9df0659fd9e3cd4fb7a3224495dc8d90a5a97168dcfb544d171"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5312e48294183a7be3b7c3c694a1cc1b6cf2255a754e1fcfd1ed95f00dcf5535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "587ca772164c3862ddf5657ae391d0bf50db10b016872c9fd7d55e50308628ac"
    sha256 cellar: :any_skip_relocation, monterey:       "f47144141c8b1e8e723c456df428bbb3dd019707c570659fd6895dcd4ffbf6b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9109166a1e4a400818d1c81093b0e4987f55032e5398964d6fb94327b34d0541"
    sha256 cellar: :any_skip_relocation, catalina:       "a83b4558a71a833afc0dc1ca957f083cff4502c027bbc515a8e2f2ecb845902b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c57c0746630fdd1b1c4cc9a427e09d83d6ba7c711fa10ff13725c0eb0a24d0"
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
