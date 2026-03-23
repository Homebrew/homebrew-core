class PnpmAT8 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.9.tgz"
  sha256 "daa27a0b541bc635323ff96c2ded995467ff9fe6d69ff67021558aa9ad9dcc36"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "d27023c0a4cd4905688132e77e2729c06816516b1e35d9c73fcc4f70aedb05bf"
    sha256 cellar: :any,                 arm64_sonoma:   "d27023c0a4cd4905688132e77e2729c06816516b1e35d9c73fcc4f70aedb05bf"
    sha256 cellar: :any,                 arm64_ventura:  "d27023c0a4cd4905688132e77e2729c06816516b1e35d9c73fcc4f70aedb05bf"
    sha256 cellar: :any,                 arm64_monterey: "d27023c0a4cd4905688132e77e2729c06816516b1e35d9c73fcc4f70aedb05bf"
    sha256 cellar: :any,                 sonoma:         "b0146e361c9446d60b53583e83ca15eb49843b7d7056db3eced35b1c7066fc8c"
    sha256 cellar: :any,                 ventura:        "b0146e361c9446d60b53583e83ca15eb49843b7d7056db3eced35b1c7066fc8c"
    sha256 cellar: :any,                 monterey:       "b0146e361c9446d60b53583e83ca15eb49843b7d7056db3eced35b1c7066fc8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e0ebd800d22d8e8c65092bfe4778a268493f5f0c4eca6df5fe9d7bcb63876245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7814ebe5944979026566edb11fa7466d282b4e7ec4fcfa6778c1a9cefdf02948"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-30", because: :unmaintained

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@8"
    bin.install_symlink bin/"pnpx" => "pnpx@8"

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm@8 requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
