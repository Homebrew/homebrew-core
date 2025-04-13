class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.8.0.tgz"
  sha256 "29bf2c5ceaea7991ee82eec15fe7162e0fad816d0c4a6b35a16c01d39274bf69"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05063079d1617489affb2cfdaa87f38aae74c2bfafe197d306ca0c0905844854"
    sha256 cellar: :any,                 arm64_sonoma:  "05063079d1617489affb2cfdaa87f38aae74c2bfafe197d306ca0c0905844854"
    sha256 cellar: :any,                 arm64_ventura: "05063079d1617489affb2cfdaa87f38aae74c2bfafe197d306ca0c0905844854"
    sha256 cellar: :any_skip_relocation, sonoma:        "b445700c660bd26dcaed207caefb38d6d133877e4c2ef1e03967fefc4f37751f"
    sha256 cellar: :any_skip_relocation, ventura:       "b445700c660bd26dcaed207caefb38d6d133877e4c2ef1e03967fefc4f37751f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1079d674d61ffc31f596fccd739bf86944293890797bbd4ed5d08e88c1d0192b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1079d674d61ffc31f596fccd739bf86944293890797bbd4ed5d08e88c1d0192b"
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
