class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-9.7.0.tgz"
  sha256 "b35018fbfa8f583668b2649e407922a721355cd81f61beeb4ac1d4258e585559"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b36c35247f89846353fca4cc96e8b866c8592a99d15151695e5dd9a911e8aa21"
    sha256 cellar: :any,                 arm64_ventura:  "b36c35247f89846353fca4cc96e8b866c8592a99d15151695e5dd9a911e8aa21"
    sha256 cellar: :any,                 arm64_monterey: "b36c35247f89846353fca4cc96e8b866c8592a99d15151695e5dd9a911e8aa21"
    sha256 cellar: :any,                 sonoma:         "f4767e04fdbe079bc2c7a79a004b5bff8b2d6eb09beb8f54a3beb37b22f42f02"
    sha256 cellar: :any,                 ventura:        "f4767e04fdbe079bc2c7a79a004b5bff8b2d6eb09beb8f54a3beb37b22f42f02"
    sha256 cellar: :any,                 monterey:       "f4767e04fdbe079bc2c7a79a004b5bff8b2d6eb09beb8f54a3beb37b22f42f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9df20acfe25e3fef0a7618f39b138506f0c94098216dee804525fba9becfc8f"
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
