class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.18.1",
      revision: "da650f4384219e13e0dad3de266501aa0b06859c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c8876e29f2c452f66002a77f0e493dd265fa79c1cc5c94aeea1ee2e5b057b6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da9c2d0be69ada88ce8501c86952b9ddb1bf1e15b0e1987902af6773a69852f6"
    sha256 cellar: :any_skip_relocation, monterey:       "ce5c71afbc3cac80824a470c8fa9d7850f8850eb614c5f6b7eec07c9124688cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a724f83fc4205118e6fe3821ecc5c3937fb09a8d6dc3597ffbbe8e8eaaae722c"
    sha256 cellar: :any_skip_relocation, catalina:       "324bcc58bede260a450f38ca1c2889f058cdf0098cb18e3a2d01b21e5f9cfe13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce48c73b9ae4156cec64dd53cea71ee8c4e799023af76d69f88ab8e5d4fe23b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
