class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.12.1/pup_1.12.1_source.tar.gz"
  sha256 "fd86874b78766f7981420639948a21ea72c232c2dbafc792ac9c862c06cd839a"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d94e744e08b0ea57795b02fee36b3480235d88aebcf80a680de7ea9afa1ec4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45278a3db5d3bdd563e85fce23f1c3ff09b9639189e026c75d6048ea0ec0bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d735b53ac4b5091874448361862563482b461cb3ac12198223963b0fe36752e"
    sha256 cellar: :any_skip_relocation, sonoma:        "692bc073187d5ec5e7adaf90841cfbf9fc99d985fed3b8c3380b6d48bf29cf8c"
    sha256 cellar: :any,                 arm64_linux:   "921a859070fa37ceb83f8412eb8cf00f0799dbeae0d042f1357124185f2e6e79"
    sha256 cellar: :any,                 x86_64_linux:  "0c195c4a3578f6fee50d0d6a6a6f28734b4f15e185999284e8aa172b4759da8e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
