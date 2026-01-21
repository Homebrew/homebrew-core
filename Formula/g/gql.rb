class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.42.0.tar.gz"
  sha256 "b7e4f935c86e934d4a4bb4f32e0982623d4239748fa9fa8d4a4a7f0dce7e36a8"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5e0640d64a69213d98ab169ad270a65aaf9eac592f3ba39a9c60c70d72cb1a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8637297d639debf15066434638144cc77ea5a57e4e9e3273b2f27daf6038c48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b69a82cc3b77732cacae2bd61dad23127e30eb8cd0fcf178503c76dd7b4c938"
    sha256 cellar: :any_skip_relocation, sonoma:        "32025f8458ae44b5829df944629a83f509dbfe4cf2da3e191b76c84ac5402248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "973032c5c3e5cab53346f33279d249663cccc00cf53aaa0feaca6cee6ca998e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5832ff15ecfb174f7d8f0dafabdb110cc95442c907b5bc7aa4bc3f0ba2bc8005"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_0"]
  end
end
