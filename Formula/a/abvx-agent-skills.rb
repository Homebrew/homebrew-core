class AbvxAgentSkills < Formula
  include Language::Python::Virtualenv

  desc "Validation-gated reusable agent skills for Codex-style project work"
  homepage "https://github.com/markoblogo/abvx-agent-skills"
  url "https://files.pythonhosted.org/packages/07/1c/c7faf0ed69db50221b3935154d3ccf1dce141f3560b83c028586d85794e8/abvx_agent_skills-0.10.0.tar.gz"
  sha256 "87c2cabafedeb2e2206efacd4d7c55e7b812e20c4fc5550d6720680105540854"
  license "MIT"

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/abvx-skills list")
    assert_match "html-diagram-artifact", output
    assert_match "html-brief-artifact", output

    destination = testpath/"skills"
    system bin/"abvx-skills", "install", "html-diagram-artifact", "html-brief-artifact",
                              "--destination", destination

    assert_path_exists destination/"html-diagram-artifact"/"SKILL.md"
    assert_path_exists destination/"html-brief-artifact"/"SKILL.md"
  end
end
