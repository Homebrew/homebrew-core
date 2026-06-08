class Punktf < Formula
  desc "Cross-platform multi-target dotfiles manager"
  homepage "https://shemnei.github.io/punktf/"
  url "https://github.com/Shemnei/punktf/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "99d5c42a621a609c59cfa5088391e4e0384739850df0eab3917b4a7d10fbebcc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/Shemnei/punktf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bc1e636ada40b6160fec2095fedbcd472a369b61ec45a1464801621b89ea61a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef7aaa4d61cf8f3bb0ebec8d120a4ac3608c7a98ed18fca64d83ac1840d5c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b2b1e0a8b29988b87a3ea87e53eca3acc461f6398b0d5d7f5eaed5aef543de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67350704bf6c38504627f458d3f6246efe92368ce4b5ee3991c974b70302267e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d96933235b92eedbfc083698c362ec32222191d87d7971f5f84ecc785c437d"
    sha256 cellar: :any_skip_relocation, ventura:       "608bd63000e880a3d2722f6379ce8103c1a01e05d651b8285ebb4cc3936d259a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f7359d14c59e8948dab52df36093bbc121645c692bc8e7e8cbda8c3ce21842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1656a42b900b124a41f8d6d155714dcf8879eea6823489b29fee3cc895b9c14d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/punktf-cli")

    generate_completions_from_executable(bin/"punktf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/punktf --version")

    mkdir_p testpath/"profiles"
    touch testpath/"profiles/test.yaml"

    output = shell_output("#{bin}/punktf deploy --profile test --source #{testpath} --target #{testpath}")
    assert_match "SUCCESS", output
  end
end
