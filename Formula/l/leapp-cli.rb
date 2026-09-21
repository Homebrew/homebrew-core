class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://www.leapp.cloud/"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.65.tgz"
  sha256 "a770256e2ce62f08c17650a30e785e46f92e7acb03e2bcbdec949054467b711c"
  license "MPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecc6de45eedbb13cdfd6657b15eeeb24ef368d4424c70ee3537d659cdc401c61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc1e7ec357d22e8c68abcb8f5b2621df647bd6a08e1c4bbc5a728ffee04c0c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94ed65f571e7a93cafbdfd13e3c48a5d2f8124775e4362267391f181099d66f9"
    sha256 cellar: :any,                 arm64_linux:       "a199c8d0df81843247b1bf519763fdde8c7d061465ba43492ee7271ef75b960d"
    sha256 cellar: :any,                 x86_64_linux:      "70795892174769c47f4fcf3bb8a44682054f626800df115138492b7c51d12f02"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "python-setuptools" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Build keytar's native addon explicitly
    cd libexec/"lib/node_modules/@noovolari/leapp-cli/node_modules/keytar" do
      system "npm", "run", "build"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        Only the `leap` CLI is installed. For Leapp.app:
          brew install --cask leapp
      EOS
    end
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
