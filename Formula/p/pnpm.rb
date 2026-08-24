class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.23.0.tgz"
  sha256 "78dcbf44f40cef50d1f4b535ca9961a30edb4b13c420c360bf4068d424a41bc4"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "187a955d366ce5dcd5ed4e4186ea2b044ba7acb9834552a6bf069f047bb7688c"
    sha256 cellar: :any,                 arm64_sequoia: "187a955d366ce5dcd5ed4e4186ea2b044ba7acb9834552a6bf069f047bb7688c"
    sha256 cellar: :any,                 arm64_sonoma:  "187a955d366ce5dcd5ed4e4186ea2b044ba7acb9834552a6bf069f047bb7688c"
    sha256 cellar: :any,                 sonoma:        "33839de96e747b9343da5b676883080ac558264abc4381096365faa3da83bb6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24113ad9f7f6f3f5aefb1d80d153498b5d773a240d268b8777ca9fc07371b4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24113ad9f7f6f3f5aefb1d80d153498b5d773a240d268b8777ca9fc07371b4af"
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
