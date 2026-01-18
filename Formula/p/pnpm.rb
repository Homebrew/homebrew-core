class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.28.0.tgz"
  sha256 "9b0b04e6e79945566917f8411bb6f65fd2f3e1590426904e8500e1acc4b33561"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c1690d8b42aa6ab84de7ef1795d5688488a6f70ec0993d902d7adf1cd1012ea"
    sha256 cellar: :any,                 arm64_sequoia: "bd6207e0941615ad9154c27b4b6e24d5a1bab9c717b8abf12bb25f45b0eaef52"
    sha256 cellar: :any,                 arm64_sonoma:  "bd6207e0941615ad9154c27b4b6e24d5a1bab9c717b8abf12bb25f45b0eaef52"
    sha256 cellar: :any,                 sonoma:        "417a114e8818e75f9bfd857348f7439313154eeb3ea9f613cf3790a30887696d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96102776f626ff6da7cfceadfa87d864307656084c15e7fa05408f2d484566da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96102776f626ff6da7cfceadfa87d864307656084c15e7fa05408f2d484566da"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

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
