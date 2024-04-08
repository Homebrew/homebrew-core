class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "ac2359deb384a8f62d3730339dad4e5f2443ab4090769536357dbe831907bb83"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2796bc29ca1186b96450f48c6ef8e78aae63b7d98dda29015d87b616642cd75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec79fda0821ca569c6137c3d592ef7d84881bd606fe85599ad703fd12d88a3d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb7de588997e0810d99cda39bd20a6f1964ae38f3c08b8eed5a5b6c987f6fff"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f44f28598b8b319d05a23f0f6942e35ccbf3e62375614f9247358c6546d6f17"
    sha256 cellar: :any_skip_relocation, ventura:        "02b99993e5f977bde506f32fc8fc6f1d1b7f9d0e69bf28ced74936bb6a762d59"
    sha256 cellar: :any_skip_relocation, monterey:       "160e512a47a453fc589c31e7ad7883bd9b787685fd14080b71091edfce0720c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf66959d35a305243779ac1433f8400d1a64f6ea51e4e3ea6d8430c08d8c232"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
