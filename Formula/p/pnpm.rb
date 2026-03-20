class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.32.1.tgz"
  sha256 "9b943b94bc8f55efb993aad8e44b538e6b091e60a9e4a944dcde869855f233e3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6b31bedf51c3bae342c3d52e5a66d286d857089d56cfde75fcd5e299e412f8f"
    sha256 cellar: :any,                 arm64_sequoia: "f686427d7df1f68c3ab94e599b32fe0c622b754e32f355911b97eccecd63a778"
    sha256 cellar: :any,                 arm64_sonoma:  "f686427d7df1f68c3ab94e599b32fe0c622b754e32f355911b97eccecd63a778"
    sha256 cellar: :any,                 sonoma:        "b49c3d43f6cf1de67081e75df18ccfc7ecf809326ecb6811a3624c2006045767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2828843ab5c10b9c72d9f9f0b5b8a50ee0d1f78b316cf9f50dac37a1623374d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2828843ab5c10b9c72d9f9f0b5b8a50ee0d1f78b316cf9f50dac37a1623374d0"
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
