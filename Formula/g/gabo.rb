class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f8498c1721308e785917c3e3532dd9027e9dcf72b5bd8145e47fced3fc9e5048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fda5dd56b3f138c38682586f889d08c4923c53b3d9f04188f2a5d239e7f308ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7753da13328338cb80b969d352e4a73d7830953ac6e0ea8be895c64803ac5b27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7753da13328338cb80b969d352e4a73d7830953ac6e0ea8be895c64803ac5b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7753da13328338cb80b969d352e4a73d7830953ac6e0ea8be895c64803ac5b27"
    sha256 cellar: :any_skip_relocation, sonoma:         "21f2773e7a6c3b4c73a48a406504dbeb4bb8dbe5be86842e0f3a65c408fd9557"
    sha256 cellar: :any_skip_relocation, ventura:        "21f2773e7a6c3b4c73a48a406504dbeb4bb8dbe5be86842e0f3a65c408fd9557"
    sha256 cellar: :any_skip_relocation, monterey:       "21f2773e7a6c3b4c73a48a406504dbeb4bb8dbe5be86842e0f3a65c408fd9557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7a48faaa45a3838d8111a2b8491250aab6261239277113fed5c828c4d8370f"
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
    assert_predicate gabo_test/".github/workflows/lint-yaml.yaml", :exist?
  end
end
