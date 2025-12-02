class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "df31128ec64c0bdb7e8c6917ad68a0c69fe4fe1bd4355332b94938ed08edc2ce"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbce92800f87da1efec15e48fadc645677ac1c690ee9d7d460d824bc088b5a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d50cf968e60eff8c5e51bf937bfd8528a7d7cb89d5df6ad8467b50b6cc7893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17369ef3f870c5a18489e7baed30d33fb571fadcade62ec1091f6d54f00abe86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ab5f7973f25bc569e1a79c7d978739a9428ce3954b4775efa76e20718e8e0d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa6a8b34c8484d0fc36febad3e465ac48f53b71ff4f596490dfee97688ee008"
    sha256 cellar: :any_skip_relocation, ventura:       "7be747e4d857c18ec1b1f4345d5f4745c65c54c782b2efc50bda45f1aa268d6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d86b9a2d4377d12ec9783e9855bc8bbd8ba06270860ff85521c0adf507fd0448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99c219b6991576f9ee16f57cb2f08f5d2081dacb1f5ce8c61136ae8c7ffbf470"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "crates/noseyparker-cli")
    mv bin/"noseyparker-cli", bin/"noseyparker"

    generate_completions_from_executable(bin/"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noseyparker -V")

    output = shell_output("#{bin}/noseyparker scan --git-url https://github.com/homebrew/.github")
    assert_match "0/0 new matches", output
  end
end
