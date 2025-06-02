class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.11.0.tgz"
  sha256 "a69e9cb077da419d47d18f1dd52e207245b29cac6e076acedbeb8be3b1a67bd7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "991ed869cc2b766673e5cf015c60d4a7a02f15ab5cb5751080c9cbe19f6c05ba"
    sha256 cellar: :any,                 arm64_sonoma:  "991ed869cc2b766673e5cf015c60d4a7a02f15ab5cb5751080c9cbe19f6c05ba"
    sha256 cellar: :any,                 arm64_ventura: "991ed869cc2b766673e5cf015c60d4a7a02f15ab5cb5751080c9cbe19f6c05ba"
    sha256 cellar: :any,                 sonoma:        "bb8ea180f59e9c1c54daa31fd13fdd25d1236440d6861af734214891f77dcc97"
    sha256 cellar: :any,                 ventura:       "bb8ea180f59e9c1c54daa31fd13fdd25d1236440d6861af734214891f77dcc97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885044cafbac9751c1c356228f291f0004bc30947a223823b61e3cedc581c3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885044cafbac9751c1c356228f291f0004bc30947a223823b61e3cedc581c3e1"
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
