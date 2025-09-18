class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.17.0.tgz"
  sha256 "bd9ec5417641391e0acb3912b2912bd5b0385407a82da94744a7407b567fdb4f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d7d6a5884dcd82cda089035185f839514bf3462d4112034b3029e35d2eb2655"
    sha256 cellar: :any,                 arm64_sequoia: "4b1b6ddda890a38341af7de8a48684c237033b8d78ef1f473f13f67af9083c5b"
    sha256 cellar: :any,                 arm64_sonoma:  "4b1b6ddda890a38341af7de8a48684c237033b8d78ef1f473f13f67af9083c5b"
    sha256 cellar: :any,                 sonoma:        "241c568c9809dd424fb44d2de55aad3d1fa06a7f12c5364e8d2d55aaf1bd877b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebbda680777f99cc9903f60b2310cf2de81025190d00c383cb5bd4151a9bd6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebbda680777f99cc9903f60b2310cf2de81025190d00c383cb5bd4151a9bd6f8"
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
