class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/39.2.0.tar.gz"
  sha256 "cdb98177f956615c961bc615fab0b30e73167295152d4f2d4cb70b16cdf47d6e"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f79f0091b2439d09a282e4731414ca240b479b9ee1dce7017808b3b793b53fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f79f0091b2439d09a282e4731414ca240b479b9ee1dce7017808b3b793b53fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f79f0091b2439d09a282e4731414ca240b479b9ee1dce7017808b3b793b53fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b489b6facee5fad90c296a0b9368296b41c592bea225f7da4806f077675954b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beedcca6635c1c157d142ec0728a1b4cf0e9dd60d933e59ad003d69120532643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323e237254fe3e24924684401b371bd6ec9a6eab779e0a0b8dcc6c7ed43b0c02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
