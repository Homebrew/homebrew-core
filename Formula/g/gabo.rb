class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "2d216d8829882d9bc4822851fa7974f1eb434fa407d1a961a6f4ef3f8bbf1fe9"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f12581b9e784a6f7157ac45c2cd4c3e5195862f71f8d5237140e01018feb6962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f12581b9e784a6f7157ac45c2cd4c3e5195862f71f8d5237140e01018feb6962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12581b9e784a6f7157ac45c2cd4c3e5195862f71f8d5237140e01018feb6962"
    sha256 cellar: :any_skip_relocation, sonoma:        "67dd3f0ebdf6b7e24341dc19f434be014963a1c26bc3e139c15b99db455c6681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88d40a76dfd2514264bcfd3f32161f315af210d59ce138aa90aff7a6047047dc"
    sha256 cellar: :any,                 x86_64_linux:  "e382f0bde4aba3a6fe2eab8b4ba4995591ba29a59917090aac45933c2f80cc06"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end
