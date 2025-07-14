class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "7a1dac697116dcefee1e1ef91bfd3ccb4a148f91f6ab6643937c5ed169cdcc85"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9dd0158523958867d1f79c97579dce7dc0d2a516d0fbaba7679193a8129cd90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9dd0158523958867d1f79c97579dce7dc0d2a516d0fbaba7679193a8129cd90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9dd0158523958867d1f79c97579dce7dc0d2a516d0fbaba7679193a8129cd90"
    sha256 cellar: :any_skip_relocation, sonoma:        "24a3dac90895e2558f98edd48904bb1f5235422c9bdc0d53cc33b12b9958d083"
    sha256 cellar: :any_skip_relocation, ventura:       "24a3dac90895e2558f98edd48904bb1f5235422c9bdc0d53cc33b12b9958d083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a122b0ff7685b4e768aa247778b7236be7d6f6ee704f6088ef165afa85edb04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
