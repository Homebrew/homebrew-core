class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5b1fd2ab73c9d90f3d3d1aa5f8bb8de75abe2093905230f496085502202d7688"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77ef2384be561f0c35b0eeb43b045ca750ac84deb91ac00f03fda4a2027decf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8545005db3856f571c1fcbeb7ff824524a4fbf7223294bfde05953fe385fdcd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3ad5d0b344c9e57dd3676ce269f5aeca8112f429369416b060a3f514711a828"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ede90d8affd7f13e50c9f43dec5e968e5dc81ce4aa68287ef7e03e904cdf898"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e03f0fbf0ff9ff72bf512a2a46c17b5b413576bbb39ca81655b61bce5d28da"
    sha256 cellar: :any_skip_relocation, ventura:       "329ebe1db268ace4d7650608ff9659ca175c8d02c24490ddb41a97f74d2b1a43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ed5ddbd8e7281a5722ee70190bcb2436cf16ba1e0ec28afad159546bf458b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92ff44a87f882ae8cb5184f67804cbdcff4340d2feab37d3aa7f2fdcb2c6686a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end
