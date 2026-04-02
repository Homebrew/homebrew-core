class BetterCommits < Formula
  desc "CLI for creating better commits following the conventional commits specification"
  homepage "https://github.com/Everduin94/better-commits"
  url "https://registry.npmjs.org/better-commits/-/better-commits-1.19.1.tgz"
  sha256 "702a0e44eff73cbf62ad67bcdade4d3746216bd44c88d8756bcf6432403286d8"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Install all binaries defined in package.json
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Test that binaries exist and are executable
    assert_path_exists bin/"better-commits"
    assert_path_exists bin/"better-branch"
    assert_path_exists bin/"better-commits-init"
    assert_path_exists bin/"bcommits"
    assert_path_exists bin/"git-bc"

    # Test that binaries are executable
    assert_predicate bin/"better-commits", :executable?

    # Test better-commits-init (should generate config successfully)
    output = shell_output("#{bin}/better-commits-init 2>&1")
    assert_match "Successfully created .better-commits.json", output
  end
end
