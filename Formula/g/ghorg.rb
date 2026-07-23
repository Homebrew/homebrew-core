class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.14.tar.gz"
  sha256 "a2ab7abe4d16764156895f257630aeb4694ad04b9886e4fb3815499a0a7d8378"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec55abdd2b35b8aaf3046a3e68dce81215958845f4e60a15ca8ac26a54f319f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec55abdd2b35b8aaf3046a3e68dce81215958845f4e60a15ca8ac26a54f319f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec55abdd2b35b8aaf3046a3e68dce81215958845f4e60a15ca8ac26a54f319f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef95b6971d67ca87d8ef2ae07ccaa091eeeeae3e570e27937dc20337dc5c8a91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f35b6994029ae2779afa1216ee9885b3bb4c3b447660c95518a79c89f5f4f05f"
    sha256 cellar: :any,                 x86_64_linux:  "98032e3ebd73c2ec9766eacdc5ed2ecde3c39f2223e618732f606a8f6e755505"
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
