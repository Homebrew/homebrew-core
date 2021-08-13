class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.13.0-0.tar.gz"
  sha256 "362f081b6728a4ef9d21411310903f8898c881faf0682649940c66335d39f5a5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7da2aca6833071eec6626c22e5026af7587cd297ce324d49b4f3bdffb60ea8ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "a82c695979562329a3b6bfe645c59d8cbf8708ff65d95ad6704bfaa023f1ce60"
    sha256 cellar: :any_skip_relocation, catalina:      "a82c695979562329a3b6bfe645c59d8cbf8708ff65d95ad6704bfaa023f1ce60"
    sha256 cellar: :any_skip_relocation, mojave:        "a82c695979562329a3b6bfe645c59d8cbf8708ff65d95ad6704bfaa023f1ce60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da2aca6833071eec6626c22e5026af7587cd297ce324d49b4f3bdffb60ea8ee"
  end

  depends_on "node@14" => :build

  # Described in https://github.com/pnpm/pnpm#installation
  # Managed by https://github.com/pnpm/get
  resource "pnpm-buildtime" do
    url "https://get.pnpm.io/v6.7.js"
    sha256 "56bffe269aab055bec3a07fa65c387f5a35729550dc7fc76711844a2de6e1b8b"
  end

  def install
    buildtime_bin = buildpath/"buildtime-bin"
    resource("pnpm-buildtime").stage do |r|
      buildtime_bin.install "v#{r.version}.js"
      (buildtime_bin/"pnpm").write_env_script "#{Formula["node@14"].bin}/node",
        buildpath/"buildtime-bin/v#{r.version}.js", {}
      chmod 0755, buildtime_bin/"pnpm"
    end
    ENV.prepend_path "PATH", buildtime_bin
    system "pnpm", "install"
    chdir "packages/pnpm" do
      system buildpath/"node_modules/.bin/tsc", "--build"
      system "pnpm", "run", "bundle"
      on_macos do
        system "node_modules/.bin/pkg", "--target=host", "--out-path=dist", "dist/pnpm.cjs"
      end
      on_linux do
        system "node_modules/.bin/pkg", "--target=linuxstatic", "--out-path=dist", "dist/pnpm.cjs"
      end
      bin.install "dist/pnpm"
    end
  end

  def caveats
    <<~EOS
      You should create pnpm's global directory if you want to install packages globally:

        mkdir -p ~/npm-global/bin

      Run the following pnpm command:

        pnpm set prefix ~/npm-global

      Add the following to #{shell_profile} or your desired shell
      configuration file:

        export PATH="$HOME/npm-global/bin:$PATH"

      You can set prefix to any location, but leaving it unchanged from
      #{HOMEBREW_PREFIX} will destroy any Homebrew-installed Node installations
      upon upgrade/reinstall.
    EOS
  end

  test do
    mkdir_p testpath/"npm-global/bin"
    ENV.prepend_path "PATH", testpath/"npm-global/bin"
    (testpath/".npmrc").atomic_write "prefix=#{testpath/"npm-global"}"
    system "#{bin}/pnpm", "env", "use", "--global", "16"
    system "#{bin}/pnpm", "install", "--global", "npm"
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
