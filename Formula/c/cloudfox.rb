class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "e6f2d5597140b812bda78b3934b17d279a36c33fb4011d6a34880806ff2ef65a"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "778c3b2df7380aeba7407aed30cce5e26667cd89b20d0f45463014c3e1863318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d16e055e2b30fed522d46e6b98ede3cd401a6124c33fc28bb0cf581c5692a832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e207507d8e06d4bdc257bd4cc82368ad1b28f2c3c138791965e2cb487edff6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04c8b3e66578e7bbef93fc1d683d0cae6062e8e4f8a69596b21e227d433df3d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "62a43a2288a1ae159b2dbb47f3d2f7be777da9ab85128b03e016502ea9526398"
    sha256 cellar: :any_skip_relocation, ventura:        "d1afef9d81470bc6c906d5590ec09196dff1a15b3355f48fef900df894648b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "faa5d819604ab9add8a8518f533abcf6d9b45b67538cfa01e4cc899b220cbae5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cebc69ca62fd774b6e2c2b24dd329a760f86d49f7a47847c1a15daf9a4a05d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8d9b2e9e66aefcf76da2a8b589f4e0148f6fc92f799ecd2847531694121d76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
