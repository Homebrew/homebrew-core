class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "e2d36aae595affcfae3f5350fd53896c2c6d1b5cecab133839404a9ef6faff2b"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fe2bedfc0f205f743e0cb86625743eb961366539e3169242dff0d221a9dfcfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fe2bedfc0f205f743e0cb86625743eb961366539e3169242dff0d221a9dfcfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe2bedfc0f205f743e0cb86625743eb961366539e3169242dff0d221a9dfcfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a89a78bea14ca93794361cc766298692c94822c2267f16b37c9e2311212b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "743f35ba14e6827a096c7d4bcb6c277f7f8a4f7d43636cb523b30c7860ad24ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae261948982d4acb9048f0520825656431ed7a85e9a0fb3a1f99c76b9c6266a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
