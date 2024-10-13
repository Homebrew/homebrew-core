class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https://github.com/praetorian-inc/noseyparker"
  url "https://github.com/praetorian-inc/noseyparker/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "517655be7377a9636dbf15ede998f4229a47ada1e3844e086e50c6fd137b5574"
  license "Apache-2.0"
  head "https://github.com/praetorian-inc/noseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b889595bce7f5825c70e7fa77b63feb13b276879c79d21688c046d4adeca9a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9efd9e3d3ce4e0fb0e5a6b7f7ffc04b964b2ac93b83afca277212ba34e2323bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "215e0dc70e747e537246982a4e6b78b13f46cf72dee5c9202eab69b622fbd8bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "35ad9ac233495d3b233c0c416f48fb8661e7a5bdfc0ddd802a1080095d06c245"
    sha256 cellar: :any_skip_relocation, ventura:       "7b7812e53e4ffa48a2df49b45efa317f71655a84f5a45dbed9b732619044ab8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f661d1b8128a4b07fc26709247c751e779e471fa786bb47bc01fddcd38cf5b2b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    output = shell_output(bin/"noseyparker scan --git-url https://github.com/homebrew/.github")
    assert_match "0/0 new matches", output
  end
end
