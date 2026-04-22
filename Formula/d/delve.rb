class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "b3be68f1207076e539268f0c502a7d399e798c18f6998860dbf0bdf80eb77f44"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40af32d7fe443fe32bc57d3f96877d0e51b2b9d496b3f12c55c060eb804912ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40af32d7fe443fe32bc57d3f96877d0e51b2b9d496b3f12c55c060eb804912ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40af32d7fe443fe32bc57d3f96877d0e51b2b9d496b3f12c55c060eb804912ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "07c48d0ac3ef19775b03469e7dd4307e15db699cbe319c2f5003e311d87b82b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86bae6359153151128044b900eec2488d7dee767c7d7e61bcc0f80aa5b184ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaddcb58f1da692a261b6a09ed5e316bafd91a8d3bccdaa573cac62cb7f39306"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
