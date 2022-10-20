class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b2627d822fae37d986df7c5e1dc65c7bb3d2485178d159acdb610902b5b91e6a"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5a6c1a2828e0eedf2df621b2a4a6db789250530e80c1ae871cace36fe1b59ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b6287e640d793241c6207dd780bf2ad4d8cb53e8c14a24f536377bd623a385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1439fdb596a7f7b5fba11f924bb1eef9f1129e30aa2bf1d157208a017985890a"
    sha256 cellar: :any_skip_relocation, ventura:        "dc01c62cede8658ea0d6b6ade7fbe22d509ce00c86aa9d1a7b55a1949da2ee24"
    sha256 cellar: :any_skip_relocation, monterey:       "694bb1f491448fa23f5623eb7d930e97b0527b79a158663618b3deca6723e322"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5f60b07334ceb536d57b0e90e76fbbe890cfbe5a4745b09346c2ebcc5ebe9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995e373aad1569d4473c3bad7afc5c50bbe5c94258595061d7146af7a83c4997"
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
