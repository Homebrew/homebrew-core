class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.29.0.tgz"
  sha256 "aa7e1646990108fb339ef6c16ccb8ab88480e657b6e1839b24ac3fe58fe24cff"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28810634bc939daf74cb4357f0694a61a1122195507859822bb85f3770000a7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28810634bc939daf74cb4357f0694a61a1122195507859822bb85f3770000a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28810634bc939daf74cb4357f0694a61a1122195507859822bb85f3770000a7e"
    sha256 cellar: :any_skip_relocation, ventura:        "6f21e4d0be266aef334bcc33097be1566ba9fbecfad51e981f123f2a63c6777b"
    sha256 cellar: :any_skip_relocation, monterey:       "6f21e4d0be266aef334bcc33097be1566ba9fbecfad51e981f123f2a63c6777b"
    sha256 cellar: :any_skip_relocation, big_sur:        "88c9aa54c5939a4d74297c160d40c37fdabbd25c73fc32f14fc414af1e17dcd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28810634bc939daf74cb4357f0694a61a1122195507859822bb85f3770000a7e"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
