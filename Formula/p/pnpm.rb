class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.9.0.tgz"
  sha256 "2b567aa66026238078ac2e0a33bec3febd60e962987aac697456f3180819b287"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3190024fd09c07edebe30a8c17a411401d37c54a489458b9b1d51cf7b31075c4"
    sha256 cellar: :any,                 arm64_sequoia: "a755e7ed7e7ba34bdd735098c291db573c8eeb0d6d73efbb881ef0b232dde339"
    sha256 cellar: :any,                 arm64_sonoma:  "a755e7ed7e7ba34bdd735098c291db573c8eeb0d6d73efbb881ef0b232dde339"
    sha256 cellar: :any,                 sonoma:        "50bca07296e7abb86fd720ce55114aedf46c1793aa1d33de62fb0ff253801450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a5addc9ca3ae864007fff957cf19dd1a4249b609e7fc9c43974a2d6b242d356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5addc9ca3ae864007fff957cf19dd1a4249b609e7fc9c43974a2d6b242d356"
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
