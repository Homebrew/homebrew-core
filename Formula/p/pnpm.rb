class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.9.0.tgz"
  sha256 "ea53ab747ac8b7921de63b42eab1adf021e1fe6ded05f62f00885cc33a46118d"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4516e1785417d58c339873ca1003e2c0ccfe8c963da7c28719def9b0fd3f5b3"
    sha256 cellar: :any,                 arm64_sonoma:  "c4516e1785417d58c339873ca1003e2c0ccfe8c963da7c28719def9b0fd3f5b3"
    sha256 cellar: :any,                 arm64_ventura: "c4516e1785417d58c339873ca1003e2c0ccfe8c963da7c28719def9b0fd3f5b3"
    sha256 cellar: :any,                 sonoma:        "980ce532b221b4f6ad9f7ab7b7d64ed99d1846d6269c1eec8fd77d635739200d"
    sha256 cellar: :any,                 ventura:       "980ce532b221b4f6ad9f7ab7b7d64ed99d1846d6269c1eec8fd77d635739200d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a1b9e6276b551f8da25d7cec34e9dfe90f8875d59a58121fcb785390e4ae568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1b9e6276b551f8da25d7cec34e9dfe90f8875d59a58121fcb785390e4ae568"
  end

  depends_on "node" => [:build, :test]

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
