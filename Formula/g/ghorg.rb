class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.12.tar.gz"
  sha256 "d3a6c0897092262f94770ace76b88fd76cf28b2f0d2c4bde37af5e446ecd5303"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcda2b9387140065e392cf8edd445b7344a4151407421925252dcb6d6f36fd69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcda2b9387140065e392cf8edd445b7344a4151407421925252dcb6d6f36fd69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcda2b9387140065e392cf8edd445b7344a4151407421925252dcb6d6f36fd69"
    sha256 cellar: :any_skip_relocation, sonoma:        "381919554ead0b742c56c72a82a6bff05c4989e759c2c5f9f7c4dee5d617756a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "205abe7f17808bb058ce605e9018f9a373e364da53b88e4f1aaac31ac5dbb56b"
    sha256 cellar: :any,                 x86_64_linux:  "a2961964a77c217d9af51c99ab87839aea4237a44767766d8d5d0a65de363b8d"
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
