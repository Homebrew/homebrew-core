class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.17.1.tgz"
  sha256 "a1e0133f6801c13039ae41309e5e5a7d1058a3a1e1edd020a4944a83c5368d04"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e515e6b25640cd4bee439e96275481225301e686daecc9b92f2bce9e70fb86dd"
    sha256 cellar: :any,                 arm64_sequoia: "97c6c2ba697db891b0fbd39ec3d1560c7a3879e8dd67885c192357442216a3b2"
    sha256 cellar: :any,                 arm64_sonoma:  "97c6c2ba697db891b0fbd39ec3d1560c7a3879e8dd67885c192357442216a3b2"
    sha256 cellar: :any,                 sonoma:        "0a508e28f52b93b063be4efe93064e522c0d5a3923fd63ac7ce5a37929c29b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c134a44d6981e8938a98a9628138274a6e6ffc4614c3220dcf7c30174b432a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c134a44d6981e8938a98a9628138274a6e6ffc4614c3220dcf7c30174b432a3"
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
