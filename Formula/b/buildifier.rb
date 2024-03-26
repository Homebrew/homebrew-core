class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "061472b3e8b589fb42233f0b48798d00cf9dee203bd39502bd294e6b050bc6c2"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93aeee5ed1632e7bd4a47bb458840d709ce955aa73cae383700831881631fe8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93aeee5ed1632e7bd4a47bb458840d709ce955aa73cae383700831881631fe8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93aeee5ed1632e7bd4a47bb458840d709ce955aa73cae383700831881631fe8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0f5523dd4cbcad9221857faeb7277a2fad4cad2e42a7fba40b6d46b3eda5a73"
    sha256 cellar: :any_skip_relocation, ventura:        "a0f5523dd4cbcad9221857faeb7277a2fad4cad2e42a7fba40b6d46b3eda5a73"
    sha256 cellar: :any_skip_relocation, monterey:       "a0f5523dd4cbcad9221857faeb7277a2fad4cad2e42a7fba40b6d46b3eda5a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0a455de960b2b6ae0709b1aa9d32f0a0000edffe07534453a4deae653239ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
