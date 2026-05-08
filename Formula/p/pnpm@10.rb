class PnpmAT10 < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.33.4.tgz"
  sha256 "8e70ddc6649b18bc3d895cf3a908c0291ea4c38039ad8722c47e018daf1e9cfc"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e5ac760ae4396dc6b5d4c05f4251299c6cf6aaf83e0a0718e3714e748b120e1"
    sha256 cellar: :any,                 arm64_sequoia: "ff2dcc524ff07e073073e65251e0e44221da83693698d37ddb20965aa984752b"
    sha256 cellar: :any,                 arm64_sonoma:  "ff2dcc524ff07e073073e65251e0e44221da83693698d37ddb20965aa984752b"
    sha256 cellar: :any,                 sonoma:        "bfc9b37c334bf64f5394905d39129a1997c440b8e416fe43124437cbfac058da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5242c1424c7d29a991dc63657248581509b80cd95bb2eb87e77879001a5d745c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5242c1424c7d29a991dc63657248581509b80cd95bb2eb87e77879001a5d745c"
  end

  keg_only :versioned_formula

  depends_on "node" => [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink bin/"pnpm" => "pnpm@10"
    bin.install_symlink bin/"pnpx" => "pnpx@10"

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
