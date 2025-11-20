class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/0.11.10.tar.gz"
  sha256 "57f4bf689ee675949d56c46f4482a16d6529b43eecf5f857e81fe18d078377b1"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b34c9d955428b70dea8ae2c72231c4a4cb5b8a9cb3c32bb7ba178965b1368b90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b34c9d955428b70dea8ae2c72231c4a4cb5b8a9cb3c32bb7ba178965b1368b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b34c9d955428b70dea8ae2c72231c4a4cb5b8a9cb3c32bb7ba178965b1368b90"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06f43e1aacc387abe40161c43579475dab1e8d4c4446bd920020c05b3aff6ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d5cc26d2ee25dec9f2f7a89841bfa4edd274875ce12c16001ab0f4535485690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c24716d51764c22d0daef821a8446d2c9948d3cabc8fd3f496e52152f3de08a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
