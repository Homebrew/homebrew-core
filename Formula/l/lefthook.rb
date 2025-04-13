class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.9.tar.gz"
  sha256 "294b364f02305c066150fc245235d622a67578038a30c660a623e12c8ccc70d5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "734c1be79cfe387eec4f538fefc8dca02b8e939cdad5d8d920116fef55efdfb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "734c1be79cfe387eec4f538fefc8dca02b8e939cdad5d8d920116fef55efdfb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "734c1be79cfe387eec4f538fefc8dca02b8e939cdad5d8d920116fef55efdfb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4edfdd29e7444f0571a273119722c0e70fc4b3ee001399f96d5493c950606494"
    sha256 cellar: :any_skip_relocation, ventura:       "4edfdd29e7444f0571a273119722c0e70fc4b3ee001399f96d5493c950606494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e936cc5e6f5a0a49a3dcb597f2b5e4595a71654a8391a214bf1c36059c213bbf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
