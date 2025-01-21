class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "d511daae76d3a67a8277adae0c09bf200d5b619f4ab1beb44218f195fc4bf890"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66ae57160daa60c2fcbedca1a7f8ac8835199879502c0a97d7cc3c923a8f176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12eaf8306c2bf632b08ed02cdfdf77a13f154b5791c7bf58754b1c5fc88b7abb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8551dfa4ff0cc80707645d4f52f07c7a186488846d4877226ec064f023f4b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "676eb6f1cf8e6260fdb91e90b6a553594391d46024790d8afc0d17de59c0c87c"
    sha256 cellar: :any_skip_relocation, ventura:       "335d60b4e467326b9f05f59d78b5fe462125b8d0f122ec8963c8429d79be7ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1294b4d9badd2ca8c90e5ffd4f28384eb39ec61cc5d1ef5e5cca61c54f40b535"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
