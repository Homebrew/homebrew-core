class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/FirefoxPWA"
  url "https://github.com/filips123/FirefoxPWA/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "b5759fef28405d82a4cc1ac6b1d15c638436738e5ce7d6d5754c781a0b88140f"
  license "MPL-2.0"
  head "https://github.com/filips123/FirefoxPWA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "322606d678649e3b358613064efb3242dfcf8fdfe6e2f7fdea126f75e54f7547"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bda2f63e00c22d6a8fb86ba284625b84dcf94a33d3f5d6c68a6691314b69e40"
    sha256 cellar: :any_skip_relocation, monterey:       "d917d9321b83aa6e31a5ad65f656878a316b5df6e95af85ff383dfebb00e0122"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d1d17cf2ddc34e185017c175c55285b89ae70ebc4f367c34af043a7a5051849"
    sha256 cellar: :any_skip_relocation, catalina:       "6f0e4d628b7d612b6c651b72b9df8f0f54f60364d5f36d67aa9849bafd6a43b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee74182cd7e9cc782ff2b67cefe7f09c29c48d1fe0e74e7814e1c5c7acb8709b"
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
