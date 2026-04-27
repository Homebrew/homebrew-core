class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.33.2.tgz"
  sha256 "7a7bcf13d7f6ceb3946c03978373d99be9fde1cafc3000bdfed4c4f791167610"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "106d1ccc08cded49cdc0114bcf587bd94785f59498499892ae97e6871c996029"
    sha256 cellar: :any,                 arm64_sequoia: "81f91c9d4c8c1741432e25a858b05743c724750a7c4b71868d6f80c85391a3a7"
    sha256 cellar: :any,                 arm64_sonoma:  "81f91c9d4c8c1741432e25a858b05743c724750a7c4b71868d6f80c85391a3a7"
    sha256 cellar: :any,                 sonoma:        "beff7d2e0e0efd1de4c06488ee9e46a640bb8eed6e3a3347dd750abee221378a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e152ade85c78558e0050943548d5288888fc813aa3063e1586a05e96cbe732fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e152ade85c78558e0050943548d5288888fc813aa3063e1586a05e96cbe732fe"
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
