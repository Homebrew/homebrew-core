class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.0.0.tgz"
  sha256 "43abf6e720fb7bc53c591b0862605c7d323d0a9d2dd33bcac07b062e13cf4948"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b16354b850572926c9cf2d19c3601bfbeba8a23851305114874ce375d48d7d41"
    sha256 cellar: :any,                 arm64_sonoma:  "b16354b850572926c9cf2d19c3601bfbeba8a23851305114874ce375d48d7d41"
    sha256 cellar: :any,                 arm64_ventura: "b16354b850572926c9cf2d19c3601bfbeba8a23851305114874ce375d48d7d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "67515a09c56ee77e93e8062c6bd7136f5a35fdc74006aad54676826c1e3e067a"
    sha256 cellar: :any_skip_relocation, ventura:       "67515a09c56ee77e93e8062c6bd7136f5a35fdc74006aad54676826c1e3e067a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb62e45c5dcd4591621d7fdbdbe8a57dc15c7bcfbac40a7ce702e8cbae2dde99"
  end

  depends_on "node" => [:build, :test]

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
