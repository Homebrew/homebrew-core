class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.33.0.tgz"
  sha256 "bfcc1bcbad279b13a516c446a75b3c58b6904b45d57a1951411015e50b751a80"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9f42f6fd7992a63fca83fa8c06d99fe367955d7e2d298b695e9070e586f3627"
    sha256 cellar: :any,                 arm64_sequoia: "ac2486f2a2216aafc086b2b30d07e1ac14febad3cba62b5ca5aa77c766f3477d"
    sha256 cellar: :any,                 arm64_sonoma:  "ac2486f2a2216aafc086b2b30d07e1ac14febad3cba62b5ca5aa77c766f3477d"
    sha256 cellar: :any,                 sonoma:        "f1691afc3c2f725533128b3d22b05fcdb34d896933cc603bd3d094a7d6e117a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174e0ef64eab77d7aa11629cd15839f479670f5b807a6a439a1ca2305dda8a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "174e0ef64eab77d7aa11629cd15839f479670f5b807a6a439a1ca2305dda8a42"
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
