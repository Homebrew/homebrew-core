class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.25.0.tgz"
  sha256 "33dd0748f27e7916c4f1c8b6943461983e3453b06bbda6312a6280130b4881e5"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7a8e74e58eaaab8d4f85e43b8ca4a31077f54083f5b87f4b98e72afa820f403"
    sha256 cellar: :any,                 arm64_sequoia: "f7a8e74e58eaaab8d4f85e43b8ca4a31077f54083f5b87f4b98e72afa820f403"
    sha256 cellar: :any,                 arm64_sonoma:  "f7a8e74e58eaaab8d4f85e43b8ca4a31077f54083f5b87f4b98e72afa820f403"
    sha256 cellar: :any,                 tahoe:         "243f479bf86802dccfe44862b5ddbc43feec74ba975295ffc105661b40f8ff0d"
    sha256 cellar: :any,                 sequoia:       "243f479bf86802dccfe44862b5ddbc43feec74ba975295ffc105661b40f8ff0d"
    sha256 cellar: :any,                 sonoma:        "243f479bf86802dccfe44862b5ddbc43feec74ba975295ffc105661b40f8ff0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "482adae72a25632a98d8d39e310f5919d99ee485c6550a8feca330771525bdea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482adae72a25632a98d8d39e310f5919d99ee485c6550a8feca330771525bdea"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  # downloads npm packages during install
  allow_network_access! :build

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
