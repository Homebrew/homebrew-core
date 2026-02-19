class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.16.0.tar.gz"
  sha256 "3add599e000f02754b2d0900c655e976cfbabb9207b8c2c0d24715c547ed738c"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b446780481078ca7709028db82ba2509ec0a06b67d0cae94ddcff24812dd9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2350d63cb6099cf07d38b36a688fb2f615a6372e85685af44df1ff96ea49bce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca251b3048bb142e15f30315114ffb6232ffd4f2253fbececf7792ce4aca01a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7227a82ae87cf2f4b05b75ec04eb954579df99a55856f9bbdedd33ad9029761c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afc7a8387f1325bb47b58eecc84499daae214ae4736b072b74eca9840c3c57b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9258b054d6d5e50feaf835cbdccb321d3101c343c59a33af480b4661d0f9b7ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
