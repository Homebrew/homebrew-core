class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.16.0.tgz"
  sha256 "3f2a848545f82fce6966f3ecaa8b7d87b5563f901a170e2bd573b02296b382fa"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebe43318d6bdb5303f9aafa7e0c9137a4c9462aea8b4970d0c109bb5f011b141"
    sha256 cellar: :any,                 arm64_sequoia: "ebe43318d6bdb5303f9aafa7e0c9137a4c9462aea8b4970d0c109bb5f011b141"
    sha256 cellar: :any,                 arm64_sonoma:  "ebe43318d6bdb5303f9aafa7e0c9137a4c9462aea8b4970d0c109bb5f011b141"
    sha256 cellar: :any,                 sonoma:        "0fb3e9b1475f3cc76b626d7638271200bd95892e904c86b8dececc38463e79f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a702a0125b9a03a904999846bd60f4f74d1480e2c778bc0ca79429dc6e429e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a702a0125b9a03a904999846bd60f4f74d1480e2c778bc0ca79429dc6e429e25"
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
