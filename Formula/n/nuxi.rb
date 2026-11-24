class Nuxi < Formula
  desc "Nuxt CLI (nuxi) for creating and managing Nuxt projects"
  homepage "https://github.com/nuxt/cli"
  url "https://registry.npmjs.org/nuxi/-/nuxi-4.1.0.tgz"
  sha256 "0c862866e1794cc31619a670b58474384bd28f5bfbe0a1ccb21ac4bd354ae16c"
  license "MIT"
  head "https://github.com/nuxt/cli.git", branch: "main"

  bottle do
    manifest_sha256 "244e0e9d9e3288b276a8514a2d4d524feec0110b9dda7eb40bb63508947de6e6"
    sha256 cellar: :any_skip_relocation, all: "d1ebaa9f86a04d505a7f5e461bfac6aebb27ff0723a2df8921567b244dc58f67"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Both aliases should be present and report the same version
    assert_match version.to_s, shell_output("#{bin}/nuxi --version")
    assert_match version.to_s, shell_output("#{bin}/nuxt --version")

    # Perform a minimal project initialization in the temporary testpath
    ENV["CI"] = "1"
    target = testpath/"nuxi-tmp"
    output = shell_output(
      "#{bin}/nuxt init . --cwd #{target} -f --template=minimal --gitInit --packageManager=npm --preferOffline",
    )
    assert_predicate target, :directory?
    assert_predicate target/".git", :directory?
    assert_path_exists target/"package.json"
    assert_match "npm run dev", output
  end
end
