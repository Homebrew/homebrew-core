class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/refs/tags/v1.1.tar.gz"
  sha256 "b42949c3f4f273651e67e5bf935b6e0393f8553da2ea54a18bca0253960104f0"
  license "MIT"
  head "https://github.com/amitsaha/gitbackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4031134b43e7809de19c4bb8370d2e26f39d8f4d6ab5c69f4506319ca9ff1a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4031134b43e7809de19c4bb8370d2e26f39d8f4d6ab5c69f4506319ca9ff1a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4031134b43e7809de19c4bb8370d2e26f39d8f4d6ab5c69f4506319ca9ff1a19"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e29126d9a0958e8e694229d6d452752c8dd466cb97d6e584bcd500f9ea8e0af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de7efa5c385da6b54a5d9d410500a7fb812eaeb6cafbb386c893f1b966f136a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb1ace4fdc8a6aad703a4d8ab2ad5e26e44ab13467f305e543a1cc9d8bc8da48"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
