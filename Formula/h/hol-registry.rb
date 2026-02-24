class HolRegistry < Formula
  desc "CLI for searching, resolving, and chatting with HOL registry agents"
  homepage "https://github.com/hashgraph-online/registry-broker-skills"
  url "https://registry.npmjs.org/@hol-org/registry/-/registry-1.5.2.tgz"
  sha256 "094751f72a00bf9460e913776c7cc3d1823a75a6de342cdc13548c14cfa76c87"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    skill_dir = testpath/"demo-skill"
    system bin/"hol-registry", "skills", "init",
           "--dir", skill_dir,
           "--name", "demo-skill",
           "--version", "0.1.0",
           "--description", "Demo skill"

    assert_path_exists skill_dir/"skill.json"
    assert_path_exists skill_dir/"SKILL.md"

    manifest = (skill_dir/"skill.json").read
    assert_match "\"name\": \"demo-skill\"", manifest
    assert_match "\"version\": \"0.1.0\"", manifest

    lint_output = shell_output("#{bin}/hol-registry skills lint --dir #{skill_dir} --json")
    assert_match "\"ok\": true", lint_output
  end
end
