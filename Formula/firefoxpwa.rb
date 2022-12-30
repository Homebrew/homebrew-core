class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b2627d822fae37d986df7c5e1dc65c7bb3d2485178d159acdb610902b5b91e6a"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1558a6a856e52313f82b85f5ea1358b3b1fb3acadbd34d00d060a3a9fd9e2ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d77f91bd01637cd8fecd2234eb97028b31fc934a613cd27e692442881a94c11e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58a87135345b16f45a4c326df018ace89ee7dfebb0149c8990f4d43a8c10310a"
    sha256 cellar: :any_skip_relocation, ventura:        "7c537d6d5cf54caeff6de306602763da8b4ce4f3c38c351a284724435c4c88e5"
    sha256 cellar: :any_skip_relocation, monterey:       "57afc4326c266129e201b03ee32cf508fd1eb9aa8c533b8af5830a8f71bd4f56"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cf73e0d52eaa752e65e6a09e3bd7b440fa2b81bceb23a361cc0322f461a7189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a23651b714d19b0e6f84c75d37dc2d982568755da649033126d127f93256e05b"
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
