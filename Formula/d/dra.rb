class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.8.1.tar.gz"
  sha256 "93b05fd57b893873af622e0324efc63f8da4688bb8115e4b104ca45d05b0ab47"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "537ded100520b5b459f4f899da12624fd07bca6b6384975a2e2ad88312dbab83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1de59fcc091a9d8a4f41ac8f785d4ea367ff298df55fe1a5f1702c7da2ba265b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30192f05fcb6db6d2819474b79a741472a32c8f4e5e5b8ffc6e0a4408f158eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "1169ee247095063ecfa4a9ccf0a0875daef510972912cf5d9fff0a180bfc66b1"
    sha256 cellar: :any_skip_relocation, ventura:       "ee84bd924fb7a7c573190693dc4b06a95a1b3a17288642b5dd2782c4aaf62e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04725a075217369ec9912611521ed0eea5a4f2e0c231ba5df1364227cb135948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb1ce502c6c2e6a8de47cc1c7c9f180a97f36ca95c98a00988708dcb519ae2c1"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_path_exists testpath/"helloworld.tar.gz"
  end
end
