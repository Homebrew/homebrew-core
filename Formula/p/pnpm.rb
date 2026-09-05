class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v12.3.4.tar.gz"
  sha256 "3e8718d9c38d61ecdb4aca9df3d1257d11fdfbed4d022d8dbc139f511b5aed66"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3027b70d8ea2a01b26eb88411c4b2dd11926c25b0a85d063f2ba16bec8962ce0"
    sha256 cellar: :any,                 arm64_sequoia: "3027b70d8ea2a01b26eb88411c4b2dd11926c25b0a85d063f2ba16bec8962ce0"
    sha256 cellar: :any,                 arm64_sonoma:  "3027b70d8ea2a01b26eb88411c4b2dd11926c25b0a85d063f2ba16bec8962ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ede465ac717deebdf76e2453a5cb263fd58d1563a91801259a5e7a71c22c3875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede465ac717deebdf76e2453a5cb263fd58d1563a91801259a5e7a71c22c3875"
  end

  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", "--offline", *std_cargo_args(path: "pnpm/crates/cli")

    # Upstream ships these beside the binary as shell scripts rather than
    # symlinks: the `dlx` injection for `pnpx`/`pnx` matches on the name of
    # the resolved `current_exe`, which a symlink would report as `pnpm`.
    (bin/"pn").write <<~SH
      #!/bin/sh
      exec "#{opt_bin}/pnpm" "$@"
    SH
    ["pnpx", "pnx"].each do |name|
      (bin/name).write <<~SH
        #!/bin/sh
        exec "#{opt_bin}/pnpm" dlx "$@"
      SH
    end
    chmod 0755, [bin/"pn", bin/"pnpx", bin/"pnx"]

    generate_completions_from_executable(bin/"pnpm", "completion")
  end

  test do
    # `pnpm init` writes a `packageManager` pin naming this exact pnpm, and
    # every later invocation resolves that pin against the registry, so
    # anything that must run without network has to come first.
    assert_match version.to_s, shell_output("#{bin}/pn --version")

    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
