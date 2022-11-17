class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.15.0.tar.gz"
  sha256 "6d708828e4641c5c596376300363a24863975ff0a5567e26affc4197d498fed3"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85d9928ffbb167e5f4d5b56f4bd19165fc30f86359e77b4e343c236bf61366bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f850767b2f9cb732293dd9a0d92a5f61fb72022f0f2e430af17e102efa390da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6957d6c9dfa6cc306cebd5c93bce8bc2db0567d94372bb3df1b9fa39272c392"
    sha256 cellar: :any_skip_relocation, ventura:        "56a7fd6ce58745544637184c55a18a53a4cdb085223ec357157e9e6dac81e42c"
    sha256 cellar: :any_skip_relocation, monterey:       "2229f74cd2cf844883c0d3a8fd5fde09e1556fa591dd9e982a075ed4e3d06f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f8972ed815d413cd0fe1a83dce86d831a6eda8ec984af07fed09e135f401417"
    sha256 cellar: :any_skip_relocation, catalina:       "ade5ea45aabf9909ed93b1c74b7ec8f3e1e3b29e751f8eaf4f27a25a6149d08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9deb02b86541ca39205b13af8dd141a111815b7acdcc280846db700713fb8070"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
