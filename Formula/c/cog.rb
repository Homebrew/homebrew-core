class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "f327885fa484656292c70dfbe71b4bf8e33343b3f751b0f5c976fc6bfb0453d0"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84b4629b2f9cd611ce9a06de46328e93df6c00f994d4da94c59782b10f0b96cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2c9985059cb40206ddab448b37aeb7b252544bba969afc2a83841df0c71cba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8740d8dca174e76901db502aef3a86d1501323ce4ee74adf4fb1ffad77ba85f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a31781f5e39caccbff1533dde1cb969c4919232883e7c12e70c7e188ea3a8a"
    sha256 cellar: :any,                 arm64_linux:   "006f0779aea4ff9f71da8afe5e0421b4912242e627e847deb2ce510cb986c7d4"
    sha256 cellar: :any,                 x86_64_linux:  "5d059bedfa270b95cdb5a44defbae181c4c21e485fe2245de8fc5592391db779"
  end

  depends_on "go" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
