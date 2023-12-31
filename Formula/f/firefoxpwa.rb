class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "ef385aab69642d532c393702754caf8a37b01c6609183aa40393490e6ff89466"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ca0db45b6ea67ce3ffac94a7fe1b4e18b666028a1e0e83dc6ba2c3819a59f2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f6ad770f5c9937b8ffa7f787f202dbf576f05a36cb2edf2b35f26acaf30e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9d1b501c1fe549c98daeadd9d14b2b7c58d9b54b99a12e1119a0b53fbcae4b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bbbddbe8c2c8e13d6c34a18c312e70c02a316e86d292fb3a5d99a11fb4a31ac"
    sha256 cellar: :any_skip_relocation, ventura:        "7f79b0acbca4d524cc500c52190ec3ef7e5b1ff5a7e7c47baf9299e23e0ed364"
    sha256 cellar: :any_skip_relocation, monterey:       "74f12f4e350b7ed8be413d6a064e5a5ba5d414f6ce4540acf3401635564801bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03f9410be94632fb00ace9470d7ebd1170b9d882465c1c404f608ab5a5c53b5"
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
