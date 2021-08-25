class Pnpm < Formula
  require "language/node"
  require "patchelf/helper"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.14.4-1.tar.gz"
  sha256 "7d4ded34e0e2ea602872e5a50bf2cbd8434fb4ef3e33f8f45a32db3f11aa9090"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c6e99eda3ac41d3f16cdc1c0f6d917020fe73acd0796531eb378080228659f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c6984eca4bf24118d0170576bde5d9c651749a19b5c106b9e542e968a0d54b5"
    sha256 cellar: :any_skip_relocation, catalina:      "1c6984eca4bf24118d0170576bde5d9c651749a19b5c106b9e542e968a0d54b5"
    sha256 cellar: :any_skip_relocation, mojave:        "1c6984eca4bf24118d0170576bde5d9c651749a19b5c106b9e542e968a0d54b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6e99eda3ac41d3f16cdc1c0f6d917020fe73acd0796531eb378080228659f1"
  end

  depends_on "node@14" => :build

  # Described in https://github.com/pnpm/pnpm#installation
  # Managed by https://github.com/pnpm/get
  resource "pnpm-buildtime" do
    url "https://get.pnpm.io/v6.14.js"
    sha256 "c80817f1dac65ee497fc8ca0b533e497aacfbf951a917ff4652825710bbacda7"
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
      system "pnpm", "run", "compile"
    end
    chdir "packages/beta" do
      system "node_modules/.bin/pkg", "--target=host", "../pnpm/dist/pnpm.cjs"
      bin.install "pnpm"
    end
  end

  def post_install
    on_linux do
      lib.mkpath
      marker = lib/"SHIFTED"
      unless marker.exist?
        executable = bin/"pnpm"
        next if executable.interpreter.size <= "/lib64/ld-linux-x86-64.so.2".size

        offset = PatchELF::Helper::PAGE_SIZE
        binary = IO.binread executable
        binary.sub!(/(?<=PAYLOAD_POSITION = ')((\d+) *)(?=')/) do
          (Regexp.last_match(2).to_i + offset).to_s.ljust(Regexp.last_match(1).size)
        end
        binary.sub!(/(?<=PRELUDE_POSITION = ')((\d+) *)(?=')/) do
          (Regexp.last_match(2).to_i + offset).to_s.ljust(Regexp.last_match(1).size)
        end
        executable.atomic_write binary
        marker.atomic_write ""
      end
    end
  end

  def caveats
    <<~EOS
      Run the following command to create the content-addressable store for the first time:

        pnpm setup

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
