class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-9.2.0.tgz"
  sha256 "49f7d2101d2178101f87f0f9231bbee85158fbae415efe10a1e340d24664c27e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7eec56aac16094b81b7e039399dc5cb788d6c4187b1629eb03c64924f1cf623e"
    sha256 cellar: :any,                 arm64_sequoia: "185f12bf249a9f4ab43e625d93c8674303deea4ea12e39cbb5d5a20ab815e2b5"
    sha256 cellar: :any,                 arm64_sonoma:  "185f12bf249a9f4ab43e625d93c8674303deea4ea12e39cbb5d5a20ab815e2b5"
    sha256 cellar: :any,                 sonoma:        "b9d2a38ed6360d854acfd9a54d52fd1e89f3af1786f3aed82d674c44e204d5d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e661dd3e5247ec2ac9d09bf65e4cdd1678a99470fb398634009afec81d09719e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c56e9ffc61a07a24942d856dedac997eb027b90859e4deef80ff4658b8b447"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
