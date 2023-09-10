class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "1a84e22d9dfd63fc0f25ab2a65d6c968f44d32c8048b9770ac57282221abb171"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222f401e5096646024d4006352987fa0c1540f37dde8562461ab298ef57dfbae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41d00fd8a9c63ab21214712f41ad7316402cdc66041fe4270301c7485590a39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27fe72ffda47fc878939eaecb9a07e2bd47129657da919c3d43f5bc2642da69a"
    sha256 cellar: :any_skip_relocation, ventura:        "fa654f59a4f5b3b303ad0bb791ef4d7b6edc7c44eea6b9c81ab87b76ba1d4f21"
    sha256 cellar: :any_skip_relocation, monterey:       "c2ad246790e36b6ab1785174569abf66cc0ef3968ad0d5ac3aef7d89eaaf2170"
    sha256 cellar: :any_skip_relocation, big_sur:        "f89c7440eda2e5981254917a4b3900e20e175b2b56e5a907c07ad9543682296a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19acd3ec7080028a64710264551eec6746fc60e218955b884a59a26427d71f8b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
