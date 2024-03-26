class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "061472b3e8b589fb42233f0b48798d00cf9dee203bd39502bd294e6b050bc6c2"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fcd6f6d525761832e7d94ad75ba0b0d95d0f020327914ffa3ad6eb78e8f18b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fcd6f6d525761832e7d94ad75ba0b0d95d0f020327914ffa3ad6eb78e8f18b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fcd6f6d525761832e7d94ad75ba0b0d95d0f020327914ffa3ad6eb78e8f18b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ca9a3ccb5ad2f8371cb3afb5e1c33fc84860d6f84ef87b2b1750a958179b502"
    sha256 cellar: :any_skip_relocation, ventura:        "9ca9a3ccb5ad2f8371cb3afb5e1c33fc84860d6f84ef87b2b1750a958179b502"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca9a3ccb5ad2f8371cb3afb5e1c33fc84860d6f84ef87b2b1750a958179b502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c12a5c274374112824bd179a162e9afee1509d44a07b1d901d4a4486eb12edb1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
