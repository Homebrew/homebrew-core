class Nuxi < Formula
  desc "Nuxt CLI (nuxi) for creating and managing Nuxt projects"
  homepage "https://github.com/nuxt/cli"
  url "https://registry.npmjs.org/nuxi/-/nuxi-3.30.0.tgz"
  sha256 "210145c695b60cfa6698aeafc9c98161b4c7c45222be62bccc13afec6a410a94"
  license "MIT"
  head "https://github.com/nuxt/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c80ea8b75bb5e1eaea79cbd67e256d59453a9e655d9b8c2ed83ed342ae8d544f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Both aliases should be present and report the same version
    assert_match version.to_s, shell_output("#{bin}/nuxi --version")
    assert_match version.to_s, shell_output("#{bin}/nuxt --version")

    # Perform a minimal project initialization in the temporary testpath
    ENV["CI"] = "1"
    target = testpath/"nuxi-tmp"
    output = shell_output(
      "#{bin}/nuxt init . --cwd #{target} -f --no-install --packageManager npm --gitInit -M --preferOffline",
    )
    assert_predicate target, :directory?
    assert_predicate target/".git", :directory?
    assert_path_exists target/"package.json"
    assert_match "npm run dev", output
  end
end
