class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "edd27d6b67232578ec4b4a2b1e725f3f0258826cf0a522630b7e1dc1f59c0ea5"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98770f4e2d24368d54c9074a0dd44a9f1307509faa2354b234d6a49225c04966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed883925f63b18ac616b54a523ed35d9d65a564a8f56ad38c8f703c7b672888e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ed29dc943a989c971acdda48a1996282f303b11cfd55f6c47094aeb59c3ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a7ca16fc34344d08a106e04f1bb5b949965ff6c6c2081a5f4fdf19e122061fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bde04eac4f78f3e6beebc105270d0c3f18a71bc214fdc5e36a1df214c6a25aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d53047e75affe4f4bc9c8fcf828f2b032d34adf4b262c102929cfd1039e35af"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
