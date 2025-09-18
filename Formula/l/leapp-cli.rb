class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.65.tgz"
  sha256 "a770256e2ce62f08c17650a30e785e46f92e7acb03e2bcbdec949054467b711c"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:    "a08d025eecfd8d28388c454b5e6c5265cdcd49996228d2f6ff08621ee1955ad5"
    sha256                               arm64_sequoia:  "a9f0381ebb60002b45fb92808def37bb0d636c0b3f843277e24e96f8a5b5b3de"
    sha256                               arm64_sonoma:   "db6a98507e65188b1fe4eb7708746e9a0e9e5fb7966a0f824b6f70ab2ca7891f"
    sha256                               arm64_ventura:  "1a9d83cc2ab81ea856376671c9cf61dfa0274030cd58db67a63b5233d8b055f8"
    sha256                               arm64_monterey: "b418a493285d50efe1cce5809193c085243026e22664ac795c8c352dcc60fa01"
    sha256                               sonoma:         "ee8f75982419c3a730061d07335b51a2911c3c22dc21a398c8d68f3bcfe8f0ba"
    sha256                               ventura:        "fe8abfb2954f71fb7c34d7611235983d0878086a378e1945d62f8686963616fb"
    sha256                               monterey:       "d53b9cb4420f95a20647b6d0ca02da15c005941889272b7aa00e4a2d1e5206cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a3b894178f3e5aacfefb391d2ad86beaee359c2ef6d5263338ec6e69eaaa9af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9b5a0a0f4dfdef5663463397ef4b2d68d917de753f7bc0ccafeda392a1356d7"
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
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
