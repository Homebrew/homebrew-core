class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.23.0.tgz"
  sha256 "a1cdd7b468386a9d78a081da05d6049d7e598db62a299db92df21a7062a4b183"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac890a2d9ff8076c9fa4f42a388d95ffb8fb9f6522f31eafdb9a3e353eb2f5fd"
    sha256 cellar: :any,                 arm64_sequoia: "3fbc85286999d20213d5b3dba6e0b77821cac338b60bf96d75c15efa650f8cd7"
    sha256 cellar: :any,                 arm64_sonoma:  "3fbc85286999d20213d5b3dba6e0b77821cac338b60bf96d75c15efa650f8cd7"
    sha256 cellar: :any,                 sonoma:        "77087f7832cec09019986703924ffe7224ea6afe9bb968dd9622ec50e0099e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0d8ed70d43a9c27aa814af64a07fe23de52e6f0da54802a189a1a177a473cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf0d8ed70d43a9c27aa814af64a07fe23de52e6f0da54802a189a1a177a473cd"
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
