class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.1.2.tgz"
  sha256 "bfe4d2b2c7a3210565bba62929f9efe493eb5f24627201a102ea4514eae8cf80"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27414cb1e9a71fddb76d72d4a7b7939026b2cab95a532624d8f23b9b499e3f4b"
    sha256 cellar: :any,                 arm64_sequoia: "16b9a878410caa9d1700d11a6b9b4c6cd8622623415b286ed944b7fdd14418b5"
    sha256 cellar: :any,                 arm64_sonoma:  "16b9a878410caa9d1700d11a6b9b4c6cd8622623415b286ed944b7fdd14418b5"
    sha256 cellar: :any,                 sonoma:        "63b0982334a33772d4951d864363cbbe988ccc854549cc00a12a1657c6716639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fda8cb3dc1c4f4d1f01825663f232936b3be963c4002e7dc79081dd096b40523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda8cb3dc1c4f4d1f01825663f232936b3be963c4002e7dc79081dd096b40523"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
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
