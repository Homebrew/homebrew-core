class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.24.0.tgz"
  sha256 "196f4bd174ebcbd99786b33452f144cb2dc32ef4e7138ed44491e9d43d702d75"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d3d546c3d31465b98cc49d92a78d2eea7d23eaae3f2e43bdc5d269d2aaafae2"
    sha256 cellar: :any,                 arm64_sequoia: "c397f0c3702d90d26fe6921c7dc165195d7b2a4e53d9ec893c0164342a43f77c"
    sha256 cellar: :any,                 arm64_sonoma:  "c397f0c3702d90d26fe6921c7dc165195d7b2a4e53d9ec893c0164342a43f77c"
    sha256 cellar: :any,                 sonoma:        "3363640fa576937bae966f840abc4345e151cb52be015fc3194472c97d111215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "879e1cef5b48358f19cbb968cd38de1d6cb1be9a7e29ff51d131155a56cde776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879e1cef5b48358f19cbb968cd38de1d6cb1be9a7e29ff51d131155a56cde776"
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
