class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "444a9e93e77a45f290a96cc09f42681d3c780cfbf4ac9dbf2939b095daeb6d7d"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece401b5a05fcfcfaa9d21658073e77464fa5ba226c8178b20828a78ffd9b3a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ece401b5a05fcfcfaa9d21658073e77464fa5ba226c8178b20828a78ffd9b3a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ece401b5a05fcfcfaa9d21658073e77464fa5ba226c8178b20828a78ffd9b3a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c9a649a7e9f846df6da90a4d8fc6800a65d4f823055339e0eab46cca8561910"
    sha256 cellar: :any_skip_relocation, ventura:       "2c9a649a7e9f846df6da90a4d8fc6800a65d4f823055339e0eab46cca8561910"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d7da0da0ea5b3d1cbb096c4061cb2af6d90eb166b33861face64521952d598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e93bb630101ed773b7440636a87f26b8132c8c17f4ca2a36b240f17ebffc5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
