class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://github.com/filips123/PWAsForFirefox"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cef7cbd33e3055e7075acb1bbfc5d58f88bc7b0707b43936b36dc326537174a1"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee173204fed41b9648a4cdfdb20d85fd8a8a3861452fce74cdbf7dec53fb6d8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1862a0c64abf4e57f8c292a9bc0df9c579ba372d4ab9ac195429b086a20afe5"
    sha256 cellar: :any_skip_relocation, monterey:       "d3d9c55dade2e1f0a54c09524a4620f240caab08e25c1951650732d4cc4e8cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d937fac3548c1977f6c0b2518c1846d672c52b75d74151e263729d3f0fcbe71"
    sha256 cellar: :any_skip_relocation, catalina:       "597a8fae39c5f6633a1657c956a4c2723b8c84861c963c46c030686aeaefecce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720b4c484d0d0d058e6832567139cd18e80bc7e5045509fc4a00773cfb313838"
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
