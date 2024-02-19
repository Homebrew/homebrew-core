require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.61.tgz"
  sha256 "9ec53e8a74cd14240d8a22f1eb5db6ef6b971d2f419712a0534da79bb252aa84"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "4c2c9c8214919a94001e87ad4182e88a150ab15eb57539247ce08072390023b3"
    sha256                               arm64_ventura:  "8eb3cf0770fb637a55b3aa251a6405ee56c64581c898a0fe591c5d370b5ce61e"
    sha256                               arm64_monterey: "137d5d7bbe6e8adfeb1cd32fc87ef86eb45f9ada05791c4f85822505b2350c6f"
    sha256                               sonoma:         "1ef685fd4b2720b8c233b9d007380da4faad2a7f6f5eeb26e788af12eba2bcc1"
    sha256                               ventura:        "1212688f5bc8c150d64b4f87e1ab65445ea63db93f95cbbcdba4e9ee1e36d59a"
    sha256                               monterey:       "94bfa1c3d16931d23a35d73fc99fa28f5648fa2785e2280130c62d4c434a151e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8961d1d889572c3eebb625d58e78b098f07631ebd8e2296b795b51e502fc28d1"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
