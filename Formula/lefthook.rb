class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "9d4ba41d0658f9439ed5a167ba07cdf17b8a5d5a93cf0b60b560aebd06f07209"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e62fe5d2aac0d8d86f724ed7ff3985facccbb29e46bcca0b62cba55d8ffa08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa1be1bd7fab3de3135d2e82f638551a36a8ea212aa8309a269540fb29dd7e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679947a8cda40ae32efe057366420a9e54c905db339673803e07ac0806722514"
    sha256 cellar: :any_skip_relocation, ventura:        "8040cb0ea59d110768d8c90411a28cc1efea00d14b992a2114d8fedaf27e3959"
    sha256 cellar: :any_skip_relocation, monterey:       "75612654151d0a7ad4ed9d4e9680bb4690f3b03d2a74775aab9f791dc3e1a04e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8be70ec3751449f84f2c0e0ce64b589d31687f52890a5a72988b212a13c110fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f591ad5f77851ea7d418a42c208a41960c430ceeb2c777a20e472220fe6c3d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
