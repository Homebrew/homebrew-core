class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.12.1.tar.gz"
  sha256 "8553aae7a6867e06f970da58389ca93b14dab7eca838e7f6b5827e1a4df24a2b"
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

  depends_on "node" => :build

  # Described in https://github.com/pnpm/pnpm#installation
  # Managed by https://github.com/pnpm/get
  resource "pnpm-buildtime" do
    url "https://get.pnpm.io/v6.7.js"
    sha256 "56bffe269aab055bec3a07fa65c387f5a35729550dc7fc76711844a2de6e1b8b"
  end

  def install
    resource("pnpm-buildtime").stage do |r|
      (buildpath/"buildtime-bin").install "v#{r.version}.js"
      IO.write "pnpm", <<~EOS
        #!/bin/sh
        node #{buildpath}/buildtime-bin/v#{r.version}.js "$@"
        exit "$?"
      EOS
      chmod 0755, "pnpm"
      (buildpath/"buildtime-bin").install "pnpm"
    end
    ENV.prepend_path "PATH", buildpath/"buildtime-bin"
    system "pnpm", "install"
    system "pnpm", "run", "compile-only"
    system "pnpm", "run", "copy-artifacts"
    on_macos do
      bin.install "dist/pnpm-macos-x64" => "pnpm"
    end
    on_linux do
      bin.install "dist/pnpm-linux-x64" => "pnpm"
    end
  end

  def caveats
    <<~EOS
      You should create npm's global directory if you want to install packages globally:

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
    IO.write testpath/".npmrc", "prefix=#{testpath/"npm-global"}"
    system "#{bin}/pnpm", "env", "use", "--global", "16"
    system "#{bin}/pnpm", "install", "--global", "npm"
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
