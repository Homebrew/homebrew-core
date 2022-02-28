class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/mongocli/v1.23.0.tar.gz"
  sha256 "7b52bf6626cf991b771fc7a62ca7c0ec6deb7012fd5a4c5ef8794b711ee69010"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cffad70e7ad2a0f5027f4816dfd4d13cf76b69f229804210d6bb03eda081b0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fec4a7fa93ca1a887e58c5247b626ec41ab330b787883356fe26e435768fbd99"
    sha256 cellar: :any_skip_relocation, monterey:       "cccbe19cf818d76e7bbf89b0c05cfbdd7bc0b2410f2bbda13a982892b9c6c6d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a78a2ce8add4da1ff999127c8284933624eb4c42e6107cccd8dc79756a60e53"
    sha256 cellar: :any_skip_relocation, catalina:       "9e18ac628f71801cafc7180415326fc1ef5c0414e26506a181e40e3503bfc011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fddaec563628cf740aaf703fb7574355c2ec50e92213109e513ec184ad2b1c2d"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    (bash_completion/"mongocli").write Utils.safe_popen_read(bin/"mongocli", "completion", "bash")
    (fish_completion/"mongocli.fish").write Utils.safe_popen_read(bin/"mongocli", "completion", "fish")
    (zsh_completion/"_mongocli").write Utils.safe_popen_read(bin/"mongocli", "completion", "zsh")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: missing credentials", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
