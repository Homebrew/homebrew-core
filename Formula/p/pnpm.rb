class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.22.0.tgz"
  sha256 "57a97e6f23a3faffc03153a4ef8c770a0552612b8640aebe39bfdd5754d0ebdc"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3d798828c5f71371f4c8bc097d99850d92ad7e9a2f81d234bc6b2daa773ac46"
    sha256 cellar: :any,                 arm64_sequoia: "e3d798828c5f71371f4c8bc097d99850d92ad7e9a2f81d234bc6b2daa773ac46"
    sha256 cellar: :any,                 arm64_sonoma:  "e3d798828c5f71371f4c8bc097d99850d92ad7e9a2f81d234bc6b2daa773ac46"
    sha256 cellar: :any,                 sonoma:        "f39113f2d37a078e7801254288927bb36e8e405a62c6973ae2234ab030102418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9c3bfae48007f3deaddfc14809bc6b3a49413c0d910d70702a415b837a9881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9c3bfae48007f3deaddfc14809bc6b3a49413c0d910d70702a415b837a9881"
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
