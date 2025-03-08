class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.6.1.tgz"
  sha256 "81204845a396962a9c4b49cc2d6cafbb49a758652d3c243f2128cbc638084fe2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e46c0bf2664191dccb42312fa503ab0797974ff1073935e6ad74629833d9ca3a"
    sha256 cellar: :any,                 arm64_sonoma:  "e46c0bf2664191dccb42312fa503ab0797974ff1073935e6ad74629833d9ca3a"
    sha256 cellar: :any,                 arm64_ventura: "e46c0bf2664191dccb42312fa503ab0797974ff1073935e6ad74629833d9ca3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "841b7f06743e26668b5ea23182b88021dc37bded5c65cf92b1535147b0e663bf"
    sha256 cellar: :any_skip_relocation, ventura:       "841b7f06743e26668b5ea23182b88021dc37bded5c65cf92b1535147b0e663bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cfced48460a3efd5094b355816d8c86e7dfd1c8c2e5fc2453c9bd534a2ab6f8"
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
