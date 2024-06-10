class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "c9aefa24bad319c6ec97aeaf386f30eeb58c30c683437559095bac74ba8235bd"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e077b04ff219ccce0871aaf483b31ccfe5d12c4ffd8213ba625f3c84f4b28d27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f6c14cc1406434f6daf857e140cd0c32c9dca41d2bb47c70ceb302a9574937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa397c2cce6a0a0a0b6551c9433b1753d9acb18f126bcee338d933dcdfef5d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed1e7a5fbac0c1637937fe48ea13a467253b4fb8bff1c472da5f20dd527f8a67"
    sha256 cellar: :any_skip_relocation, ventura:        "36db3c75182cfae1bc351e79389c6265dd3b9f47d8f08092ac6040bc03901f88"
    sha256 cellar: :any_skip_relocation, monterey:       "50815946cb5c01be4be77f085d7517aad3791eb41b002fa7c27c11bd06853564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1055ac6f845d93dcb0b036851027ee8b41d739a625162cda48507c54dc69ca2d"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first => "cog.whl"

    system "make", "install", "COG_VERSION=#{version}", "PYTHON=#{python3}", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
