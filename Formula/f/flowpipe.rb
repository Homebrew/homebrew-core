class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9f0caca307fbaa929eb3f5eb5e5af2f1399625c4418070e2d0fb71f38d275d9c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7af828df4fe17ee03673249ee248be1df80e10697ec0217dd8416aef0ed32bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3569babe8ca1378053425093ab00bf9a46618c83f80bb62e294daa2e438e9e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88ec2e0f95544b6108c9d9f80cb43497c97282e7af24b140282f8521c9d11c51"
    sha256 cellar: :any_skip_relocation, sonoma:         "4abc59f9abdaeb26dfacfeb3f3b3f28bb90e585c536ca23c5867240d0dc9caaa"
    sha256 cellar: :any_skip_relocation, ventura:        "b5ba33e3534942ac0f9d4c079e79b2a3ab91f1aa71b99eccfdf95c21d128a49c"
    sha256 cellar: :any_skip_relocation, monterey:       "726dc91548dc372b6eb62364633f10a4de898f67fba969d4197d984922cf8bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8387aa5cc46f9a17ba25d42e0ab7081f7c34c4fbadad1b780ef22ae3f3c215"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "ui/form" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")

    output = shell_output(bin/"flowpipe mod list 2>&1")
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
