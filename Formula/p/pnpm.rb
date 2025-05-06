class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.10.0.tgz"
  sha256 "fa0f513aa8191764d2b6b432420788c270f07b4f999099b65bb2010eec702a30"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d29d258e3c744f6c4227e5011629fe0f93b6a71d4d4485cfd8b2223da6ab001"
    sha256 cellar: :any,                 arm64_sonoma:  "2d29d258e3c744f6c4227e5011629fe0f93b6a71d4d4485cfd8b2223da6ab001"
    sha256 cellar: :any,                 arm64_ventura: "2d29d258e3c744f6c4227e5011629fe0f93b6a71d4d4485cfd8b2223da6ab001"
    sha256 cellar: :any,                 sonoma:        "b8f1a95d0c7ae56af113ce2add4a1a220cb97fdc1e17ca3a3a2b8bd0482ed827"
    sha256 cellar: :any,                 ventura:       "b8f1a95d0c7ae56af113ce2add4a1a220cb97fdc1e17ca3a3a2b8bd0482ed827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7f6f896ae0a98a7d082d787995506a8ea3bd72ba368ae4320cca4d97596e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec7f6f896ae0a98a7d082d787995506a8ea3bd72ba368ae4320cca4d97596e8f"
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
