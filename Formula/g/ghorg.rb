class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "e558fb63bda6a6af3951cf79778905c440cab093f33612d33184f24ad5ea7cda"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b57a87d80b7dd255e5a7653a98709c05cb6918cf63f92ee073939ad50bd51d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b57a87d80b7dd255e5a7653a98709c05cb6918cf63f92ee073939ad50bd51d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b57a87d80b7dd255e5a7653a98709c05cb6918cf63f92ee073939ad50bd51d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c334e16062db8ecbf4fd8503c0d0c9e9299970afc440e6318a388f7feab651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d1b54adf440f677810232e55887af757d7d0c5da3cd7b12bb71bb00dca0f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c720b3901186cdfa18640efd085134f10dd1500a1ac7779ae1b4dbcc2c5b505"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
