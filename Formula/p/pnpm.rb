class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.4.0.tgz"
  sha256 "e57e8a544f7a84247cfa77dd6d923eae5199a373474e53eab1f540c796289386"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5420f3a84a63f6fb38dcdc3ae6bdf0f01c6c116c866ac9146e0f947f7fc7f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "f5420f3a84a63f6fb38dcdc3ae6bdf0f01c6c116c866ac9146e0f947f7fc7f0a"
    sha256 cellar: :any,                 arm64_ventura: "f5420f3a84a63f6fb38dcdc3ae6bdf0f01c6c116c866ac9146e0f947f7fc7f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "12a6d4717cf099bf15690efdee02516de8fdb1e31226da5ef412e5b0d87f535b"
    sha256 cellar: :any_skip_relocation, ventura:       "12a6d4717cf099bf15690efdee02516de8fdb1e31226da5ef412e5b0d87f535b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19dc9d53407fb5a94b5bdb360b8464ec311470c441f6e6df1d6cd1cc69304871"
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
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
