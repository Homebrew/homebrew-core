class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "9502ee192f4dc9b524485a6373097e41db66edcfe88898346c1a80d7ea33824b"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dc8f484ac8395fdc7556f59ba76ac59c24f5fafe05c56bd18518d326edb97ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04cc3501d74c1eecec42551b76c76bcf94e6324550516dccba782b553faba41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "899b4520b7d820e92ccd70300a5267dc10b5489a322f0eee96b2812e55d36d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb2954ee3f184eee7b14bae9fff33ff99205a4b66c5487c3d532d898d1b86bb0"
    sha256 cellar: :any,                 arm64_linux:   "f157a0bcd6b9d9b9afad24cc28ba93c77130b0f93cbaabe1daf00e1b5af35db7"
    sha256 cellar: :any,                 x86_64_linux:  "80a74d4b82f3612cb83483478c55732e724f957d776000cce667915f33f20706"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end
