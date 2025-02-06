class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.0.3.tar.gz"
  sha256 "573345c2039889a4001b9933a7ebde8dcaf910c47787993aecccebc3117a4425"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f1292e85a5899b679c29dee057710ec29672b9a198d3ac3b09553027e1c3730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1292e85a5899b679c29dee057710ec29672b9a198d3ac3b09553027e1c3730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f1292e85a5899b679c29dee057710ec29672b9a198d3ac3b09553027e1c3730"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfec64a25d3507a98a3595803434cf1ccb37f7786b4a84e3266667349e280e6d"
    sha256 cellar: :any_skip_relocation, ventura:       "dfec64a25d3507a98a3595803434cf1ccb37f7786b4a84e3266667349e280e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b45c33c6863734420c87400e6ef1b6908e076b458759337ae4b02f647ebe14"
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
