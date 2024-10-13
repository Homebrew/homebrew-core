class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.12.1.tgz"
  sha256 "91452fdfa46234ae447d46d5c4fc4e7e0a7058f90495c4b6f77f8beebbb154e3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "427309802ea7572d50ead187d52497cdb2d197361ff92c0f615e1b17d3193301"
    sha256 cellar: :any,                 arm64_sonoma:  "427309802ea7572d50ead187d52497cdb2d197361ff92c0f615e1b17d3193301"
    sha256 cellar: :any,                 arm64_ventura: "427309802ea7572d50ead187d52497cdb2d197361ff92c0f615e1b17d3193301"
    sha256 cellar: :any,                 sonoma:        "6601270fa4a63b529c1c811dacb0a22c283b2bca7c675f4be076619a8ec685c8"
    sha256 cellar: :any,                 ventura:       "6601270fa4a63b529c1c811dacb0a22c283b2bca7c675f4be076619a8ec685c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c97c4a56f11c888277011bc1b7f6eea476630cf88236486da5ddabac26738ef"
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
