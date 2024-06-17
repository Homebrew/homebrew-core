class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.12.tar.gz"
  sha256 "8052b122ab18570714009a0dd0caf4ac2b437f3f7ab753b2e080a5ce21afddc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fab4af4b5b8d9a6dc100e9b96f982f7a4e213eae72804d937477b9cb4e6b4f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a8c406541603bc3a5b13b10927ee18a2a5310015b7515b274be67ccb71b6e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69a7f6cfb3abc16d60bffeb5e4b6e0b288423b3fd98a167e41f7c0ca42317448"
    sha256 cellar: :any_skip_relocation, sonoma:         "61bb49bc1b0b8ab7e4188ad7fb823013d41d808226cf2b72968939b898d05715"
    sha256 cellar: :any_skip_relocation, ventura:        "89245508d615991134cbc583c2f8f75d42a85d1be790f6d1c1bcb599608ae77a"
    sha256 cellar: :any_skip_relocation, monterey:       "670b463f106bade4f9ca3d5a3b28ca45acf20d83ee7a25643d0d15a595765652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ff1d652c963547f4ccf6cea7bc75393ee365d2f4e5ff58793d69f78fd1f62a9"
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
