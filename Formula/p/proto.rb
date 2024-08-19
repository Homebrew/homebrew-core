class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "4e5638d1270c089b81e9dc236b7563ad8be5ea4d83895eca1bcc24a6cdf4668d"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24a30729e20c6baa20a462c600b54b4bb0242ca01bffc4b4b83619d3dc184433"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93c5062e47bcb659fdc7974d117b16308603ccabf825def36b87ba15b438212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "708a020785477b8863600de7ce3515f95638dc936b2bc04f7971d1c66bbccae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a31258ab4bad84fc92a8e764ffc95df638f217c3ae50e4717252a5a624321ca7"
    sha256 cellar: :any_skip_relocation, ventura:        "b867a0a9b28ee02de273b002c4537e836c530f633db400b3e054cba58c11bac5"
    sha256 cellar: :any_skip_relocation, monterey:       "1519cc4161fb75132a20bb233e44acfb1bb8753764c6b957ca975fee41188679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a56a52adcf37973452bc658b618bde1ffc48e97fc37a8768920c715918e67248"
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
