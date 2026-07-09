class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.60/nmstate-2.2.60.tar.gz"
  sha256 "93c157c27b922968dfc6e8f649bacb00287303e0fd83b13cf1ff15a98fb3599c"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f879302d3a276b42f433bd6754d14280b779020757918e13387bba386b5949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4994135f9e26a7a4f168e3a5318bf86dc34978f77723d2ef183cbd5df2805b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb93f7b7809622eb65fd3d1c0091cd4097d10408c552068c49bb93a49d38406"
    sha256 cellar: :any_skip_relocation, sonoma:        "556c1b0b49cf92bc858f011876947d63065329646d094b65b548a746a6a3ada4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c39c5fadc2e7e4513fa2a5e7873a4de8fb24d3a99976ec957cc4fe3c048b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b48651f675cdbda8d9fa8f921035561df1d21e09e7a71d9b2d656578664af5"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      if OS.mac?
        args = ["--no-default-features"]
        features = ["gen_conf"]
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli", features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
