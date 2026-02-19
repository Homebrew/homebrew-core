class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.30.0.tgz"
  sha256 "fde3cebbd4ed0d6d140b1983743bf575cdd4b15e4d5e5b257425152dce5b1b6a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bd8d732f2f334d46895fe81c15ec31483bd87ef184470ca0f9eb9f01d99c6ca"
    sha256 cellar: :any,                 arm64_sequoia: "1ff0f003cb7c4f5941bbe4a72a0abaa78ecc6927a578c65de16b791713881815"
    sha256 cellar: :any,                 arm64_sonoma:  "1ff0f003cb7c4f5941bbe4a72a0abaa78ecc6927a578c65de16b791713881815"
    sha256 cellar: :any,                 sonoma:        "dad76734eb279dac8d1f25308e0127284d1b546869502d6f0806e2b673ff7754"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20993d79c1041e6b339b8b403981eedb0949cca246fb4c7cc70cc12f84570f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b20993d79c1041e6b339b8b403981eedb0949cca246fb4c7cc70cc12f84570f3"
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
