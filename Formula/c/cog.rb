class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "f1b9484a04ea6e532354eb5dcf807160c60db2dd06078824d93bb11aaf2ceb94"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d136eedd4f2a4c2628677f1f032a2ada3eb65fdde805a6c361c13bedbdf9625f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4e5c1a8d165ab8473d6de043fffa41833689c59e64adcd5d6b8cb4d9575d41b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "017ce3b656b9871ebe425552f27277639bff445523f469f06260ea0abdeb37c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "49d124c94604fd9d917e9a1ab56f6dd072558d3ab6b0a01babedb42a2dadf1de"
    sha256 cellar: :any_skip_relocation, ventura:        "aa23f76de878deb2acb7434e7a54aea85ae75447156bf2f4398c4441e0171a95"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7793e7bd4c244c5f875955200d00774ad56d0ffaf8efe30c716a807de1c072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dbdf6faa1a40bf7d8e0fc4b351612b191e31806fbd43e84386f3cae1cce6185"
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
