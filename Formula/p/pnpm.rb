class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.12.2.tgz"
  sha256 "2ef6e547b0b07d841d605240dce4d635677831148cd30f6d564b8f4f928f73d2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b39ffc9e6392bd54631c39965517fca93caf2669d56aeffc05bd335eb2f7fd05"
    sha256 cellar: :any,                 arm64_sonoma:  "b39ffc9e6392bd54631c39965517fca93caf2669d56aeffc05bd335eb2f7fd05"
    sha256 cellar: :any,                 arm64_ventura: "b39ffc9e6392bd54631c39965517fca93caf2669d56aeffc05bd335eb2f7fd05"
    sha256 cellar: :any,                 sonoma:        "c07dbedff49890b4de5c79002825ea04ba6988a776c6213e15303fea13def624"
    sha256 cellar: :any,                 ventura:       "c07dbedff49890b4de5c79002825ea04ba6988a776c6213e15303fea13def624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655c30d4c3ccb38e2214755a7a930f81318aad74efd56592cdcd1fa552009ac8"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
