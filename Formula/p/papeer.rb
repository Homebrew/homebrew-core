class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://github.com/lapwat/papeer/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "97c717d23a07c2aa9d9f59441e584bf9947cf9baa4c18b4dbb20f43cff3e574e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4de89940d174de2a9f2cf0efdf51bee768c9dac92cd87e19b0bb2b2f23a80bd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de89940d174de2a9f2cf0efdf51bee768c9dac92cd87e19b0bb2b2f23a80bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4de89940d174de2a9f2cf0efdf51bee768c9dac92cd87e19b0bb2b2f23a80bd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d825a41ef73efeeb45a9eac2fe3f7d9e4a26ca5b960fcaf25e5512ec11929abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "923d7f328081850271e2adf57dd7677a025fdf85377eedf0fb4c6b5e142f7572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4c0d596b575ae14c957ab4f06dce35d94aec95fd0d0285116fcfcc0a3dcb23f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end
