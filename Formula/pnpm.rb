class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "841299b2eedbbfde1ea7e0afff78cb23d33310158887e48b945bfddd882d4b61"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efcac832dc165a64bbb93b7018876cf7dc70d669ae3b1f2a68c46ea0bcddc572"
    sha256 cellar: :any_skip_relocation, big_sur:       "9eb2f3321905d4d8cf6e42aefdb051b128d91d8114e49e122a23c05af5c767cc"
    sha256 cellar: :any_skip_relocation, catalina:      "9eb2f3321905d4d8cf6e42aefdb051b128d91d8114e49e122a23c05af5c767cc"
    sha256 cellar: :any_skip_relocation, mojave:        "9eb2f3321905d4d8cf6e42aefdb051b128d91d8114e49e122a23c05af5c767cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efcac832dc165a64bbb93b7018876cf7dc70d669ae3b1f2a68c46ea0bcddc572"
  end

  depends_on "node" => :build

  BUILDTIME_PNPM_VERSION = "v6.12.0".freeze

  resource "pnpm-buildtime" do
    on_macos do
      url "https://github.com/pnpm/pnpm/releases/download/#{BUILDTIME_PNPM_VERSION}/pnpm-macos-x64"
      sha256 "42f72a9d64a3b76fa4bc5d73d1b93c4948b6bcc1725bce5f26d6cd256020b1a5"
    end
    on_linux do
      url "https://github.com/pnpm/pnpm/releases/download/#{BUILDTIME_PNPM_VERSION}/pnpm-linux-x64"
      sha256 "90e7180d4ad0a281dd499833c849c34a0e97c9a345a66ce6bdf3022e5dd7de2f"
    end
  end

  def install
    resource("pnpm-buildtime").stage do
      on_macos do
        mv "pnpm-macos-x64", "pnpm"
      end
      on_linux do
        mv "pnpm-linux-x64", "pnpm"
      end
      chmod 0755, "pnpm"
      (buildpath/"buildtime-bin").install "pnpm"
    end
    ENV.prepend_path "PATH", buildpath/"buildtime-bin"
    system "pnpm", "install"
    system "pnpm", "run", "compile-only"
    on_macos do
      bin.install "packages/artifacts/macos-x64/pnpm"
    end
    on_linux do
      bin.install "packages/artifacts/linux-x64/pnpm"
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
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
