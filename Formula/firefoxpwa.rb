class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cef7cbd33e3055e7075acb1bbfc5d58f88bc7b0707b43936b36dc326537174a1"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1878f2af24d9a836306a907f195ef91f8993b362dfd9b09b26849a36776aaae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "deeb9b786e37f655635a18b8066ac2ce7d1ae736815beda9d900d3753fd29f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "14569e3c06262583152b5fed3085759ebdf51be363724cc8194e0fa9327d456c"
    sha256 cellar: :any_skip_relocation, big_sur:        "492bc17e28724fd82408bd23ef9f07bc32acd0983c56d90703cc0cd052bbb4ac"
    sha256 cellar: :any_skip_relocation, catalina:       "fb421b693e1b85b5eb0ffde1390ec2cdc4b591d4c9bf4083e59ff4c12f39d428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6422ce946aa89d6448dc58b38d2215486d4021dc5299c10ffa355a76858889"
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
