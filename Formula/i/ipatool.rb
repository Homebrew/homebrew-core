class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "cc2371353bb00a8050e0d2ba2f4819b6401e26ba3aede5d8ed40812037b59638"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dcf3f1e12a65a08468bd7b8d99bc77acbcf8696a12428b050f9006698ed8a1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff62a9b35c52ded1c5646f3395ac6d433f8d091ccfe6e3c150dd432e62ce89ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c22121736355451767894e5ecfb7b6faf7b9b501335368608d453e7612ca6c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9b79898fa15c8d84273dfe513b6b7ea15386f6a7a4e83cca18346bd31eff4cc"
    sha256 cellar: :any_skip_relocation, ventura:       "d91f027c5fabd83e52e50bb62a9debb0f90c53dc2520298c8f7ddde5f7819220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6a95ac765d5b50c68bf9f044d25d49396eed63ae94968246077d6ef87b53cb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
