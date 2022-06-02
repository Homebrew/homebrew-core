class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "b853af50c6361838a90b50bdedd374571fcc09e7f3fdec436c233f0a316b0327"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92d827f6607eba1f9b231394dd6c6f6e07b3040ab4f95273716668de0451c66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d64e11376f7fbe461c83cdca59cd1fed4273c5d504726cef71b0a9aadbfd317"
    sha256 cellar: :any_skip_relocation, monterey:       "99928d69cd90ee79411d36ebf1aa6fe0edd57b3f80f2385ca25060ae031701e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6b2bb8e227f9b5de35dca6abc5eeb200ae632e8a9babd5422e7e89d2dd4e2c5"
    sha256 cellar: :any_skip_relocation, catalina:       "cf8026248307c77456efdedb5cd290299a64e901f24368da672ee791adf0f787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e300d7f11a521bfdc23749eccef0ee8c9d5ad53a74ecb66c690c7a7ce1a2c8f8"
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
    assert_includes output, "Site does not exist"
  end
end
