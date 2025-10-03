class Babelfish < Formula
  desc "Translate bash scripts to fish"
  homepage "https://github.com/bouk/babelfish"
  url "https://github.com/bouk/babelfish/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "967a9020e905f01b0d3150a37f35d21e8d051c634eebf479bc1503d95f81a1d9"
  license "MIT"
  head "https://github.com/bouk/babelfish.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67fa97472345f1e6a97179815c7c741904c41b6d0c349e9cb94076e2dce9cf02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f8115802286fe41309a1b8b9291312e08f2b0ebdb65c4d928d59b8189bae38c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f8115802286fe41309a1b8b9291312e08f2b0ebdb65c4d928d59b8189bae38c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f8115802286fe41309a1b8b9291312e08f2b0ebdb65c4d928d59b8189bae38c"
    sha256 cellar: :any_skip_relocation, sonoma:        "edaf31144744c63fd91293ddaf4c5f5cdc96217c3c5df59065d95d04839ecbde"
    sha256 cellar: :any_skip_relocation, ventura:       "edaf31144744c63fd91293ddaf4c5f5cdc96217c3c5df59065d95d04839ecbde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169834375c342c0ebcc87f43e78190c2c16bfd1b610da40fc3d6b27dc80dca87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828cb037747b3780fc6b91d03e1377c3220ec7ea7a86f87e9db928e89bbffcc6"
  end

  depends_on "go" => :build
  depends_on "fish" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-w -s", gcflags: "all=-l -B -wb=false")
    fish_function.install "babel.fish"
  end

  def caveats
    <<~EOS
      The shell hook has been installed, you can use it by running:

        $ source #{HOMEBREW_PREFIX}/share/fish/vendor_functions.d/babel.fish
    EOS
  end

  test do
    script = 'echo ${#@}'
    translated = pipe_output(bin/"babelfish", script)
    assert_equal "0", pipe_output("fish", translated).strip
  end
end
