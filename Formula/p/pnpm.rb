class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.18.2.tgz"
  sha256 "93421022fe0156d7cbdf699edc3d7eab39654986eac14f927d02b85f0dac6d61"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "739ad62aee18ab9955c83df77e2348dbc43f92e1fed51398b6b3c83821d2310d"
    sha256 cellar: :any,                 arm64_sequoia: "ef8eab9aedda8c18719e5019f85c2ff90c30804a8e6a874a619aaf08744d23de"
    sha256 cellar: :any,                 arm64_sonoma:  "ef8eab9aedda8c18719e5019f85c2ff90c30804a8e6a874a619aaf08744d23de"
    sha256 cellar: :any,                 sonoma:        "97edf1470d17c23d205ef4056be72d876b85d24cac3e9a6f24bff22cff0eabcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46014d67af39534f3d6e43b5f201b0548f37674bcbe745fa2f1d217c15fc22d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46014d67af39534f3d6e43b5f201b0548f37674bcbe745fa2f1d217c15fc22d3"
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
