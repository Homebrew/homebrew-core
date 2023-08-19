class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "b520cf5caeeca1d23043a032137f7eead7eb88270e5376c5d08b1234bb90376f"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565032eb2e83f1e081d48fdfc6ec9a31aea789e003c8d4e5c28c54c865b0d4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "287c295c659ca90fbcaba14c1656adaca7e88b0ff92a28b4e8e4bec9b26ff039"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c55de909818bc287b31c376bb9469cef332603b76de7359a1a345f945e4b262"
    sha256 cellar: :any_skip_relocation, ventura:        "17fdec85a7c8f358e57fe520c15c9e555b219c2d79251f5e76b88972d89d2436"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5e30e40040fbdd8b9742f4559fcaf684b2dcf271b5da00bbd4427ed27d391f"
    sha256 cellar: :any_skip_relocation, big_sur:        "251e878ee08b3e29712f2a93a38382dd8ae525509f7e0b2482591f9294548ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb04f3cd6538f24e4e7f4aab3b03a9fc55d8e3f346048379dc13d9327b85947"
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
