class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.13.1.tgz"
  sha256 "0f9ed48d808996ae007835fb5c4641cf9a300def2eddc9e957d9bbe4768c5f28"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9eebfef90b9b6dcbd9f35dbda683c5ca856cdfcf8b5c90a1dce994e3aa1aa2b"
    sha256 cellar: :any,                 arm64_sonoma:  "f9eebfef90b9b6dcbd9f35dbda683c5ca856cdfcf8b5c90a1dce994e3aa1aa2b"
    sha256 cellar: :any,                 arm64_ventura: "f9eebfef90b9b6dcbd9f35dbda683c5ca856cdfcf8b5c90a1dce994e3aa1aa2b"
    sha256 cellar: :any,                 sonoma:        "0e9f54f0bbd76bfa6c872168a0050b5199b5087978c4d9ef48fc24685a084508"
    sha256 cellar: :any,                 ventura:       "0e9f54f0bbd76bfa6c872168a0050b5199b5087978c4d9ef48fc24685a084508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8355656726d21bdf5b9a5a207672c522597b645385e85f63840c3b970643281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8355656726d21bdf5b9a5a207672c522597b645385e85f63840c3b970643281"
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
