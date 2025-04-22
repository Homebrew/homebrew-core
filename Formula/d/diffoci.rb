class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "650554edbc7118e6fb7008865281e5dba6bc6d82a417a1e0e0ea05c1561ee402"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272794b529802bbfca33f07801190a23adb3506727b2d92e06af1d1b3b65f714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272794b529802bbfca33f07801190a23adb3506727b2d92e06af1d1b3b65f714"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "272794b529802bbfca33f07801190a23adb3506727b2d92e06af1d1b3b65f714"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d68d1a0c3ea3d9fe1fc230151f3d671c3215a54869ef1278b1a8706bb1857cd"
    sha256 cellar: :any_skip_relocation, ventura:       "0b1dbe2f83d047a7f1833904eec6cdfcae6fb07e823f586cd9f7c3607162bb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e49d15e23b675401ff366c143fb50f819646f3211614b254de78d7c35d506d1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", "completion")
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
